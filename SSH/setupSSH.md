#### Установка ssh на Ubuntu/Debian.

sudo apt update 

sudo apt install ssh

sudo apt install openssh-server

sudo systemctl enable --now ssh

sudo systemctl status ssh

sudo systemctl enable ssh

sudo systemctl stop ssh

sudo systemctl start ssh

##### Меняем порт.

sudo nano /etc/ssh/sshd_config

port 2212

sudo systemctl restart sshd

sudo systemctl status ssh


##### Отключение.

sudo systemctl disable ssh --now

##### Подключение через powershell
ssh имя пользователя@192.168.133.128 -p 2212

#### Установка ssh на Centos.

yum install epel-release

sudo apt update

sudo apt install ssh

sudo apt install openssh-server

yum install policycoreutils-python

sudo systemctl status ssh

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/af7833c7-e519-4753-82e9-7c87c1c7f558)

sudo systemctl enable ssh

sudo systemctl stop ssh

sudo systemctl start ssh

##### Меняем порт.

sudo semanage port -l | grep ssh

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/0c7e9c1e-4273-4aeb-8137-816871efeb12)

sudo semanage port -a -t ssh_port_t -p tcp 2255

sudo semanage port -l | grep ssh

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/7fcbf9ee-d3f5-4cc2-9286-43fa8f565018)

firewall-cmd --list-ports

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/43958ecf-0e17-4084-aeb9-610c95dee388)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ce03d1a9-4fce-4e8a-b1c2-f407cd0c6024)


![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/6851e5ab-04b6-4c79-89bf-900713ccc405)

sudo systemctl restart sshd

sudo systemctl status ssh

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/6f4c6393-e37c-47ca-b019-077c38d5087d)



