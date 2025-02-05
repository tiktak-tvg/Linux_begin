#### Настройка Ubuntu Server

Для того, чтобы дата в консоли отображалась на русском языке, а время в 24-х часовом формате, достаточно сформировать locale ru_RU и изменить только формат времени, оставив все остальное на английском языке.

```bash
sudo locale-gen ru_RU.UTF-8
sudo update-locale LANG=en_US.UTF-8 LC_TIME="ru_RU.UTF-8"
sudo locale
sudo locale -a -v
```

Посмотреть все пояса
```bash
timedatectl list-timezones | grep Europe
```

изменяем текущий часовой пояс.
```bash
sudo timedatectl set-timezone Europe/Moscow
hostnamectl set-hostname posdb
```

Посмотреть версию релиза
```bash
lsb_release -a
Посмотреть версию ядра
```bash
uname -r
```

```bash
apt update
apt upgrade
apt list --upgradable
reboot
apt install update-notifier-common
```

```bash
cd /etc/apt/apt.conf.d
nano 50unattended-upgrades
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
```

```bash
nano 20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";

systemctl status unattended-upgrades.service
cd ..

apt install cockpit
systemctl status cockpit.socket
systemctl start cockpit.socket  
```
Cockpit создан с целью облегчения администрирования ОС Linux.<br>
После установки нам необходимо в браузере перейти на 9090 порт сервера, на котором установлен Cockpit (ip-сервера:9090). Например, 192.168.10.100:9090
```bash
ufw status
```

Отключить сообщения Ubuntu Pro:
```bash
sudo pro config set apt_news=false
```

```bash
adduser vmsoft
sudo usermod -a -G sudo vmsoft
compgen -u
```

```bash
apt install lxde-core lxappearance -y
reboot
```

```bash
sudo apt install xrdp
adduser xrdp ssl-cert
nano /etc/xrdp/startwm.sh
#test -x /etc/X11/Xsession && exec /etc/X11/Xsession
#exec /bin/sh /etc/X11/Xsession
lxsession -s LXDE -e LXDE
reboot
```

```bash
nano /etc/ssh/sshd_config
systemctl restart sshd
```

```bash
nano /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens160:
      dhcp4: no
      addresses:
        - 192.168.3.46/22
      routes:
       - to: default
       - to: 192.168.96.0/21
         via: 192.168.3.231
         on-link: true
      nameservers:
        addresses:
          - 192.168.3.210
    ens192:
      dhcp4: no
      addresses:
        - 109.95.217.162/27
      gateway4: 109.95.217.161
      nameservers:
        addresses:
          - 192.168.3.210
  version: 2
  renderer: NetworkManager

netplan apply

ip ro add 192.168.96.0/21 via 192.168.3.231
```

