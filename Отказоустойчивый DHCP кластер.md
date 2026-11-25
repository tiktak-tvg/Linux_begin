## Настройка отказоустойчивого DHCP-кластера на Linux

Практическое руководство по развёртыванию отказоустойчивого DHCP-сервера (High Availability / Failover) на Linux.

В современных дистрибутивах Linux (RHEL 8/9, РЕД ОС, Debian 11/12, Ubuntu 22.04/24.04) официальным стандартом является **ISC Kea DHCP** (пришёл на смену устаревшему `isc-dhcp-server`, поддержка которого завершилась в конце 2022 года). В руководстве приведены оба варианта: современный на базе **Kea DHCP** (основной) и классический на базе **ISC DHCP** (для legacy-систем вроде CentOS 7 / RHEL 7).

---

## Архитектура решения

Отказоустойчивость DHCP работает на прикладном уровне без необходимости использования плавающего VIP-адреса (`Keepalived`):

* **Клиенты** отправляют широковещательный запрос `DHCPDISCOVER`, который получают **оба** сервера (через L2-сегмент или `ip helper-address` / `dhcp-relay` на маршрутизаторе).
* **Серверы** синхронизируют базу выданных аренд (leases) между собой по выделенному TCP-каналу.
* **Режимы работы:**
  * **Load-Balancing (Active-Active):** оба узла активно обслуживают клиентов, деля пул адресов пополам (50/50) по хешу MAC-адреса клиента. При отказе одного узла второй забирает 100% пула.
  * **Hot-Standby (Active-Passive):** основной узел (`primary`) выдаёт все адреса, резервный (`standby`) находится в горячем резерве, принимает копии аренд и вступает в работу только при потере связи с основным узлом.

### Исходные данные для примера
* **Подсеть клиентов:** `192.168.10.0/24`
* **Шлюз по умолчанию:** `192.168.10.1`
* **DNS-серверы:** `192.168.10.2, 192.168.10.3`
* **Пул выдачи адресов:** `192.168.10.100 – 192.168.10.200`
* **Узел 1 (`dhcp-01`, Primary):** `192.168.10.11`
* **Узел 2 (`dhcp-02`, Secondary / Standby):** `192.168.10.12`

---

## Вариант 1. Современный стек: ISC Kea DHCP (рекомендуемый)

В Kea за отказоустойчивость отвечает встроенный модуль `libdhcp_ha.so` и управляющий демон `kea-ctrl-agent` (взаимодействие по REST API).

### Шаг 1. Установка пакетов (на обоих узлах)

**RHEL 8/9, AlmaLinux, Rocky Linux, РЕД ОС:**
```bash
dnf install epel-release -y
dnf install kea -y
```

**Debian 11/12, Ubuntu 22.04/24.04:**
```bash
apt update
apt install kea-dhcp4-server kea-ctrl-agent -y
```

### Шаг 2. Настройка файрвола и синхронизации времени (на обоих узлах)

Для корректной работы таймеров аренды время на серверах должно быть строго синхронизировано (`chronyd`). Также необходимо открыть порты:
* `67/udp` — трафик DHCP;
* `8000/tcp` (или `8001/tcp`) — REST API агента `kea-ctrl-agent` для синхронизации узлов.

```bash
# Проверка времени
timedatectl set-ntp true

# Firewalld (RHEL / РЕД ОС)
firewall-cmd --add-service=dhcp --permanent
firewall-cmd --add-port=8000/tcp --permanent
firewall-cmd --reload

# UFW (Ubuntu / Debian)
ufw allow 67/udp
ufw allow 8000/tcp
```

### Шаг 3. Настройка Kea Control Agent (на обоих узлах)

Файл `/etc/kea/kea-ctrl-agent.conf` обеспечивает связь между узлами кластера по HTTP/REST. Укажите локальный IP-адрес каждого сервера в параметре `http-host`:

```json
{
  "Control-agent": {
    "http-host": "192.168.10.11",
    "http-port": 8000,
    "control-sockets": {
      "dhcp4": {
        "socket-type": "unix",
        "socket-name": "/run/kea/kea4-ctrl-socket"
      }
    }
  }
}
```
*(На втором сервере `dhcp-02` замените `"http-host"` на `"192.168.10.12"`).*

### Шаг 4. Настройка Kea DHCPv4 с модулем HA

Отредактируйте `/etc/kea/kea-dhcp4.conf` на **первом узле (`dhcp-01`)**.

> **Важно:** Пути к библиотекам (`libdhcp_lease_cmds.so` и `libdhcp_ha.so`) зависят от ОС:
> * RHEL / РЕД ОС: `/usr/lib64/kea/hooks/`
> * Debian / Ubuntu: `/usr/lib/x86_64-linux-gnu/kea/hooks/`

```json
{
  "Dhcp4": {
    "interfaces-config": {
      "interfaces": [ "eth0" ]
    },
    "control-socket": {
      "socket-type": "unix",
      "socket-name": "/run/kea/kea4-ctrl-socket"
    },
    "lease-database": {
      "type": "memfile",
      "persist": true,
      "name": "/var/lib/kea/kea-leases4.csv",
      "lfc-interval": 3600
    },
    "valid-lifetime": 28800,
    "renew-timer": 14400,
    "rebind-timer": 25200,

    "hooks-libraries": [
      {
        "library": "/usr/lib64/kea/hooks/libdhcp_lease_cmds.so"
      },
      {
        "library": "/usr/lib64/kea/hooks/libdhcp_ha.so",
        "parameters": {
          "high-availability": [
            {
              "this-server-name": "dhcp-01",
              "mode": "load-balancing",
              "heartbeat-delay": 10000,
              "max-response-delay": 60000,
              "max-ack-delay": 5000,
              "max-unacked-clients": 5,
              "peers": [
                {
                  "name": "dhcp-01",
                  "url": "http://192.168.10.11:8000/",
                  "role": "primary",
                  "auto-failover": true
                },
                {
                  "name": "dhcp-02",
                  "url": "http://192.168.10.12:8000/",
                  "role": "secondary",
                  "auto-failover": true
                }
              ]
            }
          ]
        }
      }
    ],

    "subnet4": [
      {
        "id": 1,
        "subnet": "192.168.10.0/24",
        "pools": [
          { "pool": "192.168.10.100 - 192.168.10.200" }
        ],
        "option-data": [
          { "name": "routers", "data": "192.168.10.1" },
          { "name": "domain-name-servers", "data": "192.168.10.2, 192.168.10.3" },
          { "name": "domain-name", "data": "corp.local" }
        ]
      }
    ]
  }
}
```

#### Настройка второго узла (`dhcp-02`)
Скопируйте конфигурацию `/etc/kea/kea-dhcp4.conf` на второй узел и измените в ней только одну строку:
```json
"this-server-name": "dhcp-02",
```
*(Если нужен режим Active-Passive, замените `"mode": "load-balancing"` на `"mode": "hot-standby"`, а роль второго сервера на `"role": "standby"`).*

### Шаг 5. Проверка синтаксиса и запуск служб

На обоих узлах проверьте конфигурацию и запустите службы:

```bash
# Проверка валидности JSON и конфигурации
kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
kea-ctrl-agent -t /etc/kea/kea-ctrl-agent.conf

# Запуск и добавление в автозагрузку
systemctl enable --now kea-ctrl-agent kea-dhcp4
```

### Шаг 6. Проверка статуса кластера

Проверить состояние синхронизации можно через локальный REST API или сокет:

```bash
curl -s -X POST -H "Content-Type: application/json"   -d '{ "command": "status-get", "service": [ "dhcp4" ] }'   http://192.168.10.11:8000/ | jq .
```

В ответе в блоке `"high-availability"` должно отображаться состояние:
* `"state": "load-balancing"` (или `"hot-standby"`) — кластер работает штатно;
* `"communication-interrupted": false` — связь между узлами установлена.

---

## Вариант 2. Классический стек: ISC DHCP Server (для CentOS 7 / старых систем)

Используется встроенный протокол **DHCP Failover Protocol** (порт `647/tcp`).

### Шаг 1. Установка
```bash
# CentOS 7 / RHEL 7
yum install dhcp -y

# Debian / Ubuntu
apt install isc-dhcp-server -y
```

### Шаг 2. Конфигурация Primary-узла (`dhcp-01`)

Файл `/etc/dhcp/dhcpd.conf`:

```text
authoritative;
ddns-update-style none;

# Описание пиринга отказоустойчивости
failover peer "dhcp-failover" {
    primary;
    address 192.168.10.11;
    port 647;
    peer address 192.168.10.12;
    peer port 647;
    max-response-delay 30;
    max-unacked-updates 10;
    load balance max seconds 3;
    mclt 1800;
    split 128; # 128 из 256 = балансировка 50/50 (для Active-Passive указать 255)
}

subnet 192.168.10.0 netmask 255.255.255.0 {
    option routers 192.168.10.1;
    option subnet-mask 255.255.255.0;
    option domain-name "corp.local";
    option domain-name-servers 192.168.10.2, 192.168.10.3;

    pool {
        failover peer "dhcp-failover";
        range 192.168.10.100 192.168.10.200;
    }
}
```

### Шаг 3. Конфигурация Secondary-узла (`dhcp-02`)

Файл `/etc/dhcp/dhcpd.conf` (отличается только блок `failover peer` — в нём нет параметров `mclt` и `split`, а `address` и `peer address` поменяны местами):

```text
authoritative;
ddns-update-style none;

failover peer "dhcp-failover" {
    secondary;
    address 192.168.10.12;
    port 647;
    peer address 192.168.10.11;
    peer port 647;
    max-response-delay 30;
    max-unacked-updates 10;
    load balance max seconds 3;
}

subnet 192.168.10.0 netmask 255.255.255.0 {
    option routers 192.168.10.1;
    option subnet-mask 255.255.255.0;
    option domain-name "corp.local";
    option domain-name-servers 192.168.10.2, 192.168.10.3;

    pool {
        failover peer "dhcp-failover";
        range 192.168.10.100 192.168.10.200;
    }
}
```

### Шаг 4. Запуск и проверка
Откройте порт `647/tcp` и `67/udp` на обоих серверах, проверьте синтаксис и запустите службу:

```bash
dhcpd -t -cf /etc/dhcp/dhcpd.conf
systemctl enable --now dhcpd
```

Проверить состояние кластера можно в логах (`/var/log/messages` или `journalctl -u dhcpd`) — должна появиться запись `peer dhcp-failover: I move from recover to normal`.

---

## Чек-лист при вводе в эксплуатацию

1. **DHCP Relay (IP Helper):** Если клиенты находятся в других VLAN, на маршрутизаторе/коммутаторе L3 должны быть прописаны **оба** DHCP-сервера (`ip helper-address 192.168.10.11` и `ip helper-address 192.168.10.12`).
2. **Безопасность API (Kea):** В продакшене рекомендуется закрыть порт `8000/tcp` файрволом от всех хостов, кроме IP-адреса второго DHCP-узла, или настроить TLS + Basic Auth в `kea-ctrl-agent.conf`.
3. **Тестирование отказа:** Поочерёдно остановите службу DHCP на первом и втором узле (`systemctl stop kea-dhcp4`), убедитесь, что клиенты продолжают получать IP-адреса, а после запуска узла база аренд автоматически синхронизируется.
