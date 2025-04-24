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
