Установка Ansible
Для установки Ansible открываем терминал в режим суперпользователя командой:
```bash
su-
dnf install ansible
```

Подключение клиентских хостов
1) В файле /etc/ansible/hosts прописать все хосты, на которые будет распространяться конфигурация. Хосты можно разделить по группам, а так же, если у вас есть домен, то автоматически экспортировать список из домена. Можно прописывать как ip адреса так и имена хостов, если они резолвятся DNS ом в сети. Для теста пропишем 2 хоста.
```bash
[test]
10.10.1.111
10.10.1.74
```
2) Подключение к хостам осуществляется по протоколу ssh с помощью rsa ключей. Сгенерировать серверный ключ можно командой ниже. При её выполнении везде нажмите Enter.
```bash
ssh-keygen -C "$(whoami)@$(hostname)-$(date -I)"
3) Далее нужно распространить ключ на все подключенные хосты. Распространить ключи на хосты можно командой:
```bash
ssh-copy-id root@server
где:

root - это пользователь, от имени которого будут выполняться плейбуки;

server - IP-адрес хоста.

Пример: root@10.10.1.74 .
```

Проверка подключения клиентских хостов
Пингуем удаленные хосты с помощью Ansible:
```bash
 ansible test -m ping 

 test-1 | success >> {
     "changed": false, U
     "ping": "pong"
 }
 
 test-2 | success >> {
     "changed": false, 
     "ping": "pong"
 }

Где test - это группа хостов, указанная в файле hosts. В результате под каждым хостом должно быть написано "ping": "pong".
```

Создание плейбука и его выполнение
Плейбуки являются сценариями, выполняемыми на удаленных хостах. Создаем каталог, для хранения наших playbooks, которые пишутся на языке YAML:
```bash
mkdir /etc/ansible/playbooks
Для примера создадим плейбук, устанавливающий программы. В каталоге /etc/ansible/playbooks создаем файл install_programm.yml:
```bash
touch /etc/ansible/playbooks/install_programm.yml
```
Содержимое файла следующее:
```bash
---
- hosts: all
tasks:
- name: Install programm
dnf:
name: "{{ packages }}"
vars:
packages:
- unrar
- p7zip
```
В данном примере для установки используется модуль dnf. Применяется массив packages для установки. В него вписываются необходимые для установки программы.

Если хотите, можно проверить, на каких хостах будет происходить работа, командой:
```bash
ansible-playbook /etc/ansible/playbooks/install_programm.yml --list-host
```
Запустить только что созданный набор инструкций можно следующей командой:
```bash
ansible-playbook /etc/ansible/playbooks/install_programm.yml
```

Выполнение одиночной команды
С помощью Ansible возможно сразу на всех клиентах выполнить команду bash без создания плейбуков. Просмотрим информацию об использовании оперативной памяти на удаленных хостах:
```bash
 ansible test -a "free -h" 

 test-1 | success | rc=0 >>
              total       used       free     shared    buffers     cached
 Mem:          7.6G       6.4G       1.2G       471M        64M       1.2G
 -/+ buffers/cache:       5.2G       2.4G
 Swap:         4.0G       616M       3.4G
 
 test-2 | success | rc=0 >>
              total       used       free     shared    buffers     cached
 Mem:          3.9G       3.3G       573M       333M       4.8M       442M
 -/+ buffers/cache:       2.9G       1.0G
 Swap:         4.0G       1.7G       2.3G
```

Обновление Ansible до версии 6.4.0
Пакеты Ansible версии 6.Х располагаются в подключаемом репозитории, поэтому порядок обновления несколько отличается от обычного.

Установка и обновление пакетов Ansible до версии 6.Х на РЕД ОС 7.3 производится с помощью следующих команд (потребуются права пользователя root):
```bash
 dnf install ansible6-release    # подключение репозитория
 dnf clean all     # очистка метаданных
 dnf makecache     # загрузка метаданных из всех репозиториев
 dnf install ansible     # установка новой версии ansible 6.4
```
