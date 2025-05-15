#### Установка контролеров домена ALD PRO на Астра Линукс 1.7.6.
##### Предварительная подготовка сервера.
Проверяем на рекомендуемое соответствие.
```bash
cat /etc/astra/build_version
sudo astra-modeswitch getname
sudo astra-modeswitch list
Если режим другой, то выбирайте нужный
sudo astra-modeswitch set 2 
```
Добавим и запустить службу синхронизации времени chrony в автозапуск.
>[!Warning]
>Серверная служба chronyd (пакет chrony) Может обеспечивать работу ОС в режиме как сервера точного времени, так и клиента. Является штатной службой времени для использования с контроллерами домена FreeIPA.

```bash
sudo systemctl status chrony
если не установлена, установить можно так
sudo apt install chrony
sudo systemctl start chrony
sudo systemctl enable chrony
```
Добавим Российские NTP сервера и можно указать разрешённую сеть для клиентов.
Вводим ``nano /etc/chrony/chrony.conf`` и добавляем эти строки
```bash
server 0.ru.pool.ntp.org iburst
server 1.ru.pool.ntp.org iburst
server 2.ru.pool.ntp.org iburst
server 3.ru.pool.ntp.org iburst
allow 192.168.25.0/24
```
После настройки сервера нужно перезапустить службу: ``sudo systemctl restart chrony``

Проверим источники времени:``sudo chronyc -N sources``

Проверим порт. Сервер времени chrony, также как и другие NTP сервера слушает порт udp 123: ``sudo ss -ulpn | grep chronyd``

Можем посмотреть количество активных и не активных источников: ``sudo chronyc activity``

Сделаем перезагрузку и убедимся, что служба запускается автоматически.

>[Warning]
>Теперь нужно, на остальных серверах, прописать наш сервер Chrony в качестве источника синхронизации времени.
>Для этого укажем его адрес в ``/etc/systemd/timesyncd.conf`` на остальных серверах. А затем перезапустим службу синхронизации времени
```bash
[Time]
NTP=192.168.25.100
```

При необходимости увеличить таймайт запроса проля sudo.(не обязательно) 
Допишите в конце строки через запятую следующую опцию timestamp_timeout=x. Должно получиться так:
```bash
Defaults env_reset, timestamp_timeout=30
```
##### Настраиваем сеть.
Узнаём название сетевого интерфейса, IP адресс, шлюз
```bash
ip a | grep inet 
route 
```
Отключаем ipv6 на всех интерфейсах кроме lo
>[!Warning]
>Отключение IPv6 настройкой параметров ядра сделано в ОС Astra Linux по умолчанию (см. выше файл /etc/sysctl.d/999-astra.conf), однако при наличии загруженного модуля ядра IPv6 служба NetworkManager по умолчанию сама назначает сетевым интерфейсам адреса IPv6. 
>Независимо от используемой аппаратной платформы для успешной работы серверов (реплик) FreeIPA сетевой интерфейс обратной петли (loopback, lo) должен иметь адрес IPv6.

Поэтому делаем так:
```bash
sudo systemctl status NetworkManager //проверяем статус службы NetworkManager
sudo systemctl stop NetworkManager //останавливает службу
sudo systemctl disable NetworkManager //удаляет её из автозагрузки
sudo systemctl mask NetworkManager //останавливает активность службы
astra-noautonet-control disable // выключаем оснастку NetworkManager
```
```bash
nano  /etc/sysctl.d/999-astra.conf
# Astra sysctl config

kernel.sysrq = 0
fs.suid_dumpable = 0
kernel.randomize_va_space = 2
net.ipv4.tcp_timestamps = 0
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 0
```
Применяем настройки
```bash
sysctl --system
```
Установливаем статический IP адрес.

Настраиваем статический адрес вводим команду: ``nano /etc/network/interfaces``
```bash
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.25.100
netmask 255.255.255.0
gateway 192.168.25.10
```
Вводим команду ``nano /etc/resolv.conf`` и прописываем DNS, чтобы пока у нас работали репозитории
```bash
search it.company.lan
nameserver 77.88.8.8
```
Также в файл hosts добавим строки с именем сервера ``nano /etc/hosts``.
```bash
127.0.0.1       localhost.localdomain localhost
# 127.0.1.1     dc01.it.company.lan dc01   --обязательно закоментировать
192.168.25.100  dc01.it.company.lan dc01

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
Настраиваем ``FQDN`` имя первого контроллера домена:
```bash
hostnamectl set-hostname dc01.it.company.lan
```
Проверяем
```bash
hostname -s
hostname -f
hostname -I
```
Перезапустим сетевой интерфейс для применения настроек
```bash 
systemctl restart networking.service
```
Добавляем репозитории
>[!Warning]
>Репозиторий base включает репозитории main и update, а репозиторий extended содержит большое количество дополнительного программного обеспечения.

Вводим команду ``nano /etc/apt/sources.list``
```bash
# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC Основной репозиторий
#deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free
# Оперативные обновления основного репозитория
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free
# Рекомендуемые репозитории для установки сервера
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-base/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-extended/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-update/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-update/ 1.7_x86-64 main contrib non-free
```
или можно так

```bash
deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-main 1.7_x86-64 main non-free contrib
deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-update 1.7_x86-64 main contrib non-free
или эти
deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-base 1.7_x86-64 main non-free contrib
deb http://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.4/repository-extended 1.7_x86-64 main contrib non-free
```
Проверить наличие пакетов можно командой: ``apt policy apt-transport-https ca-certificates``

Для ALD PRO в папкe source.list.d добавим файл с записью
```bash
cat > /etc/apt/sources.list.d/aldpro.list
deb https://dl.astralinux.ru/aldpro/frozen/01/2.5.0 1.7_x86-64 main base
```
Обнавляем
```bash
apt update && sudo apt list --upgradable && sudo apt dist-upgrade -y -o Dpkg::Options::=--force-confnew
```
Устанавливаем необходимые пакеты:
```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q aldpro-mp aldpro-gc aldpro-syncer
```
- aldpro_enable_syncer – установка модуля синхронизации ``aldpro-syncer``. Этот модуль необходим для использования расширенных функций интеграции с доменом Microsoft Active Directory.
- aldpro_enable_gc – установка модуля глобального каталога ``aldpro-gc``. Этот модуль необходим, если используется топология из контроллера домена и нескольких реплик. Службы, предоставляемые этим модулем, выполняют синхронизацию данных пользователей между контроллером домена и его репликами.

После завершения установки проверим журнал на наличие ошибок:
```bash
sudo grep error: /var/log/apt/term.log
```

##### Установка первого контроллера ALD Pro.

После предварительной настройки продолжаем установку.

1. Теперь повысим сервер до контроллера домена. Дополнительно отключим историю выполнения команд, чтобы пароль не был записан в эту историю:
```bash
set +o history
sudo aldpro-server-install -d it.company.lan -n dc01 -p 'QwertyQAZWSX' --ip 192.168.25.100 --no-reboot --setup_syncer --setup_gc
```
2. Дожидаемся окончания процедуры повышения сервера до контроллера домена и проверяем:

Проверка статуса поднятия домена
```bash
sudo aldproctl status
sudo ipactl status
```
3. Включаем обратно историю ведения команд:
```bash
set -o history
```
4. Проверим настройки разрешения имен:
```bash
sudo cat /etc/resolv.conf
```
В файле должен быть указан ваш домен и адрес сервера – 127.0.0.1, т.к. этот файл настраивается на службу bind9.

5. Перезагружаем сервер.

Входим в домен.

##### Отключение DNSSEC
```bash
sudo sed -i 's/dnssec-validation yes/dnssec-validation no/g' /etc/bind/ipa-options-ext.conf
sudo systemctl restart bind9-pkcs11.service

sudo cat > /etc/bind/ipa-options-ext.conf
allow-recursion { any; };
allow-query-cache { any; };
```
Настройка глобального перенаправления DNS

Роли и службы сайта → Служба разрешения имён → Глобальная конфигурация DNS
Указать IP-адрес внешнего резолвера
![image](https://github.com/user-attachments/assets/d6f86c4b-62fe-4df8-a5e7-c2c62aef3beb)

Например: 77.88.8.8 или 8.8.8.8 или 1.1.1.1

Добавить права для УЗ admin
```bash
kinit
```
```bash
ipa group-add-member 'ald trust admin' --user admin
```
##### Установка второго контроллера ALD Pro.

##### Предварительная подготовка сервера.
Проверяем на рекомендуемое соответствие.
```bash
cat /etc/astra/build_version
sudo astra-modeswitch getname
sudo astra-modeswitch list
Если режим другой, то выбирайте нужный
sudo astra-modeswitch set 2 
```
Добавим и запустить службу синхронизации времени chrony в автозапуск.
```bash
sudo systemctl status chrony
если не установлена, установить можно так
sudo apt install chrony
sudo systemctl start chrony
sudo systemctl enable chrony
```
Добавим Российские NTP сервера и можно указать разрешённую сеть для клиентов.
Вводим ``nano /etc/chrony/chrony.conf`` и добавляем эти строки
```bash
server 0.ru.pool.ntp.org iburst
server 1.ru.pool.ntp.org iburst
server 2.ru.pool.ntp.org iburst
server 3.ru.pool.ntp.org iburst
allow 192.168.25.0/24
```
##### Настраиваем сеть.
Узнаём название сетевого интерфейса, IP адресс, шлюз
```bash
ip a | grep inet 
route 
```
Отключаем ipv6 на всех интерфейсах кроме lo
>[!Warning]
>Отключение IPv6 настройкой параметров ядра сделано в ОС Astra Linux по умолчанию (см. выше файл /etc/sysctl.d/999-astra.conf), однако при наличии загруженного модуля ядра IPv6 служба NetworkManager по умолчанию сама назначает сетевым интерфейсам адреса IPv6. 
>Независимо от используемой аппаратной платформы для успешной работы серверов (реплик) FreeIPA сетевой интерфейс обратной петли (loopback, lo) должен иметь адрес IPv6.

Поэтому делаем так:
```bash
sudo systemctl status NetworkManager //проверяем статус службы NetworkManager
sudo systemctl stop NetworkManager //останавливает службу
sudo systemctl disable NetworkManager //удаляет её из автозагрузки
sudo systemctl mask NetworkManager //останавливает активность службы
astra-noautonet-control disable // выключаем оснастку NetworkManager
```
```bash
nano  /etc/sysctl.d/999-astra.conf
# Astra sysctl config

kernel.sysrq = 0
fs.suid_dumpable = 0
kernel.randomize_va_space = 2
net.ipv4.tcp_timestamps = 0
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 0
```
Применяем настройки
```bash
sysctl --system
```
Установливаем статический IP адрес.

Настраиваем статический адрес вводим команду: ``nano /etc/network/interfaces``
```bash
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.25.101
netmask 255.255.255.0
gateway 192.168.25.10 // пока прописываем шлюз интернета, чтобы обновить репозитории, потом поменяем на gateway 192.168.25.100
```
Вводим команду ``nano /etc/resolv.conf`` и прописываем DNS, чтобы пока у нас работали репозитории
```bash
search it.company.lan
nameserver 77.88.8.8
```
На dc01.it.company.lan в файле /etc/resolv.conf должно быть так 
```bash
# auto-generated by IPA installer
search it.company.lan
nameserver 127.0.0.1
```
Также в файл hosts добавим строки с именем сервера ``nano /etc/hosts``.
```bash
127.0.0.1       localhost.localdomain localhost
# 127.0.1.1     dc02.it.company.lan dc02   --обязательно закоментировать
192.168.25.101  dc02.it.company.lan dc02

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
Настраиваем ``FQDN`` имя первого контроллера домена:
```bash
hostnamectl set-hostname dc02.it.company.lan
```
Проверяем
```bash
hostname -s
hostname -f
hostname -I
```
Перезапустим сетевой интерфейс для применения настроек
```bash 
systemctl restart networking.service
```
Добавляем репозитории
Вводим команду ``nano /etc/apt/sources.list``
```bash
# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC Основной репозиторий
#deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free
# Оперативные обновления основного репозитория
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free
# Рекомендуемые репозитории для установки сервера
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-base/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-extended/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-update/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-update/ 1.7_x86-64 main contrib non-free
```
Проверить наличие пакетов можно командой: ``apt policy apt-transport-https ca-certificates``

Для ALD PRO в папкe source.list.d добавим файл с записью
```bash
cat > /etc/apt/sources.list.d/aldpro.list
deb https://dl.astralinux.ru/aldpro/frozen/01/2.5.0 1.7_x86-64 main base
```
Обнавляем
```bash
apt update && sudo apt list --upgradable && sudo apt dist-upgrade -y -o Dpkg::Options::=--force-confnew
```
Устанавливаем необходимые пакеты:
```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q aldpro-mp aldpro-gc aldpro-syncer
```
- aldpro_enable_syncer – установка модуля синхронизации ``aldpro-syncer``. Этот модуль необходим для использования расширенных функций интеграции с доменом Microsoft Active Directory.
- aldpro_enable_gc – установка модуля глобального каталога ``aldpro-gc``. Этот модуль необходим, если используется топология из контроллера домена и нескольких реплик. Службы, предоставляемые этим модулем, выполняют синхронизацию данных пользователей между контроллером домена и его репликами.

После завершения установки проверим журнал на наличие ошибок:
```bash
sudo grep error: /var/log/apt/term.log
```
**После предварительной настройки продолжаем установку.**

Заменим шлюз в файле interfaces вводим команду: ``nano /etc/network/interfaces``
```bash
# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.25.101
netmask 255.255.255.0
gateway 192.168.25.100
```
Меняем сервер имён DNS в  ``nano /etc/resolv.conf``, делаем IP первого контроллера домена
```bash
search it.company.lan
nameserver 192.168.25.100
```
Перезапустим сетевой интерфейс для применения настроек
```bash 
systemctl restart networking.service
```
На этапе ввода в домен **Заблокировать изменение файла**
```bash 
sudo chattr +i /etc/resolv.conf
```
После ввода в домен **Разблокировать изменение файла**
```bash 
sudo chattr -i /etc/resolv.conf
```
1. Теперь повысим сервер до контроллера домена как клиента. Перед этим отключим историю выполнения команд, чтобы пароль не был записан в эту историю:
```bash
set +o history
/opt/rbta/aldpro/client/bin/aldpro-client-installer --domain ald.it.lan --account admin --password 'QwertyQAZWSX' --host dc2 --gui --force
```
2. Дожидаемся окончания процедуры повышения сервера до контроллера домена и проверяем:

Проверка статуса поднятия домена
```bash
sudo aldpro-client-installer
sudo freeipal-client-installer
```
3. Включаем обратно историю ведения команд и снимаем изменение файла:
```bash
set -o history

sudo chattr -i /etc/resolv.conf
```
4. Редактируем настройки разрешения имен:
```bash
sudo cat /etc/resolv.conf
```
В файле должен быть указан ваш домен и адрес сервера – 127.0.0.1, т.к. этот файл настраивается на службу bind9.
5. Перезагружаем сервер.

Входим в домен.

Отключение DNSSEC
```bash
sudo sed -i 's/dnssec-validation yes/dnssec-validation no/g' /etc/bind/ipa-options-ext.conf
sudo systemctl restart bind9-pkcs11.service
```











