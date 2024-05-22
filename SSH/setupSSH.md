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

firewall-cmd --zone=public --add-port=2255/tcp --permanent

firewall-cmd --reload

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ce03d1a9-4fce-4e8a-b1c2-f407cd0c6024)

sudo systemctl restart sshd

sudo systemctl status ssh

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/6f4c6393-e37c-47ca-b019-077c38d5087d)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/31b41b87-4287-4ce5-b66e-32bb6424a502)

Редактируем ``nano /etc/ssh/sshd_config``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/cfaf1c7e-2202-4550-a5b3-b5be70085ff3)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/73c2123a-aed4-4de0-8e4b-c99b266ddd06)


![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/b6c20e57-10e5-49a4-a447-8d8a3d327673)


