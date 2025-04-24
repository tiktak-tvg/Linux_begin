#### Установка absible на debian.
Выполняем команды:

```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install software-properties-common
Если уж вообще жопа, можно установить репозиторий.
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get install ansible
ansible --version
```
После установки будет созданы конфигурационные файлы, которые находятся в расположениях:

```
/etc/ansible/hosts — спсиок хостов для управления
/etc/ansible/ansible.cfg — непосредственно настройки ansible
```
```bash
Установка Ansible
Установку делаем на master-сервере.

Добавим репозиторий ansible:

mcedit /etc/apt/sources.list
Вставляем:

deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main
Добавляем ключ репозитория:

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
Обновляем репозитории:

apt update
Установка:

Проверим все зависимости
apt --fix-broken install
и запускаем установку
apt install ansible
Проверяем:

ansible --version
root@ubsrv:~# ansible --version
ansible [core 2.12.10]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 22 2023, 10:22:35) [GCC 9.4.0]
  jinja version = 2.10.1
  libyaml = True
root@ubsrv:~# 


[ ] - В данные скобки мы указываем название группы серверов.
[dev]

ansible_host - ip адрес.
Пример: ansible_host = 0.0.0.0

ansible_user - имя пользователя для подключения на удаленный сервер.
Пример: ansible_user - test

ansible_pass - Пароль пользователя.
Пример: ansible_pass = 12345

ansible_ssh_private_key_file - путь до закрытого ключа. Для входа без участия пароля.
Пример: ansible_ssh_private_key_file = /home/test/.ssh/id_rsa

ansible_port - порт подключения ssh.
Пример: ansible_port = 2222

[dev]
ansible_host = 0.0.0.0
ansible_user - root
ansible_pass = XXXXXXX
ansible_ssh_private_key_file = /home/root/.ssh/id_rsa

```
