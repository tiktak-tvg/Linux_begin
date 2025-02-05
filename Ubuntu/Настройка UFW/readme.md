```bash
sudo ufw allow from 104.22.11.213 to any port 25 proto tcp

sudo ufw allow 80/tcp comment 'Allow Apache HTTP'
sudo ufw allow 443/tcp comment 'Allow Nginx HTTPS'

sudo ufw allow 41194/udp comment 'Allow WireGuard VPN'
```

Открытие диапазонов портов TCP и UDP
```bash
sudo ufw allow 4000:4200/tcp comment '....'
sudo ufw allow 6000:7000/udp
```

Как разрешить подключение на определенном интерфейсе
Откройте TCP-порт 22 только для интерфейса wg0:
```bash
sudo ufw allow in on ens33 to any port 22

sudo ufw delete allow 80/tcp
sudo ufw delete allow 443/tcp
sudo ufw delete deny 23/tcp
sudo ufw delete allow 22/tcp

sudo ufw status numbered
sudo ufw status verbose
sudo ufw show added
```

```bash
root@ub01:~# sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
2269/tcp                   ALLOW IN    192.168.1.47
_______________________________________________________
root@ub01:~# sudo ufw show added
Added user rules (see 'ufw status' for running firewall):
ufw allow from 192.168.1.47 to any port 2269 proto tcp

_________________________________________________________
root@ub01:~# sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 2269/tcp                   ALLOW IN    192.168.1.47

__________________________________________________________
root@ub01:~# sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
2269/tcp                   ALLOW       192.168.1.47
```

Отключение файервола:
```bash
$  sudo ufw disable
```

Включение файервола:
```bash
$  sudo ufw enable
$  sudo ufw reset
```

```bash
$  sudo ufw show added | grep 192.168.1.47
ufw allow from 192.168.1.47 to any port 2269 proto tcp
$ 

sudo ufw deny 23/tcp comment 'Block telnet'
sudo ufw deny from 1.2.3.4
sudo ufw deny from 103.13.42.42/28
sudo ufw deny from 1.1.1.2 to any port 22 proto tcp
____________________________________________________________
sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 2269/tcp                   ALLOW IN    192.168.1.47

sudo ufw delete 1
sudo ufw status numbered
```

```bash
$ sudo ufw limit ssh/tcp comment 'Rate limit for openssh serer'
$ sudo ufw status
### if sshd is running on tcp port 2022 add ####
$ sudo ufw limit 2022/tcp comment 'SSH port rate limit'
```

ufw заблокировать определенный IP-адрес
Синтаксис:
```bash
sudo ufw deny from {ip-address-here} to any
```

Чтобы заблокировать или отклонить все пакеты от 192.168.1.5, введите:
```bash
sudo ufw deny from 192.168.1.5 to any
```

Заблокировать IP-адрес ufw
Вместо правила отказа мы можем отклонить соединение с любого IP следующим образом:
```bash
sudo ufw reject from 202.54.5.7 to any
```

ufw блокирует определенный IP и номер порта
Синтаксис:
```bash
sudo ufw deny from {ip-address-here} to any port {port-number-here}
```

Чтобы заблокировать или запретить отправку спамеров с IP-адреса 202.54.1.5 на порт 80, введите:
```bash
sudo ufw deny from 202.54.1.5 to any port 80
```

ufw запрещает определенный IP, номер порта и протокол
Синтаксис следующий, когда вам нужно заблокировать по IP-адресу, номеру порта и протоколу:
sudo ufw deny proto {tcp|udp} from {ip-address-here} to any port {port-number-here}

Например, заблокируйте IP-адрес хакера 202.54.1.1 на TCP-порт 22, введите:
```bash
sudo ufw deny proto tcp from 202.54.1.1 to any port 22

sudo ufw deny proto tcp from sub/net to any port 22
sudo ufw deny proto tcp from 202.54.1.0/24 to any port 22
```

Как удалить заблокированный IP-адрес или снова разблокировать IP-адрес?
Синтаксис такой: Чтобы удалить правило № 4, введите: Примеры выходных данных:
```bash
sudo ufw status numbered
sudo ufw delete NUM
```

```bash
sudo nano /etc/ufw/before.rules
```

Добавьте правило для блокировки спамеров или хакеров:
```bash
# Блокировать спамеров 
-A ufw-before-input -s 178.137.80.191 -j DROP
 # Блокировать ip/net (подсеть) 
-A ufw-before-input -s 202.54.1.0 / 24  -j DROP
Сохраните и закройте файл. Наконец, перезагрузите брандмауэр:
sudo ufw reload
```
