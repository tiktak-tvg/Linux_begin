#### Установка ssh на Linux.

sudo apt update && sudo apt upgrade

reboot

sudo apt install ssh

sudo apt install openssh-server

sudo systemctl enable --now ssh

sudo systemctl status ssh

sudo systemctl enable ssh

##### Меняем порт.

sudo nano /etc/ssh/sshd_config

port 2212

sudo systemctl restart ssh

или

sudo systemctl restart sshd

##### Отключение.

sudo systemctl disable ssh --now

##### Подключение через powershell
ssh имя пользователя@192.168.133.128 -p 2212

