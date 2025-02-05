##### Настройка postgresql

```bash
wget https://repo.postgrespro.ru/pg1c-13/keys/pgpro-repo-add.sh
sh pgpro-repo-add.sh
```

Если наш продукт единственный Postgres на вашей машине и вы хотите
сразу получить готовую к употреблению базу:
```bash
apt-get install postgrespro-1c-13
```

Чтобы найти имя демона PostgreSQL выполним команду.
```bash
systemctl --type=service | grep postgres
```
> Пример вывода:
``postgrespro-1c-13.service``  

Теперь останавливаем сервис и удаляем созданный по умолчанию кластер.

Останавливаем PostgreSQL
```bash
sudo systemctl stop postgrespro-1c-13
```

Удаляем файлы ранее созданного при установке кластера

Вместо 1c-13 может быть другое название каталога, в зависимости от версии.
```bash
rm -r /var/lib/pgpro/1c-13/data/*
```

Инициализируем новый кластер для 1С с нужной локалью (не обязательно, если по умолчанию локаль в системе "ru_RU.UTF-8").
```bash
sudo /opt/pgpro/1c-13/bin/pg-setup initdb --tune=1c --locale=ru_RU.UTF-8
```

Запускаем PostgreSQL
```bash
sudo systemctl start postgrespro-1c-13
```

Настройка postgre
```bash
nano /var/lib/pgpro/1c-13/data/postgresql.conf
```

Разрешим подключение к СУБД с любых адресов. Для этого в файле конфигурации сервера (/var/lib/pgpro/1c-13/data/postgresql.conf) изменим строчку:
```bash
# listen_addresses = 'localhost'
listen_addresses = '*'
```
``nano /var/lib/pgpro/1c-13/data/pg_hba.conf``

Также разрешим подключение для всех пользователей по логину и паролю. В файле (/var/lib/pgpro/1c-13/data/pg_hba.conf) изменим разрешения для IPv4.
```bash
# Было
# # IPv4 local connections:
# host    all             all             127.0.0.1/32            md5

# Стало
# IPv4 local connections:
host    all             all             0.0.0.0/0               password
host    all             all             127.0.0.1/32            md5
```

Расшариваем папку
```bash
apt-get insall samba
```
Демон или сервис Samba называется smbd. Под таким именем и будем к нему обращаться.
Добавим сервис smbd в автозапуск:
```bash
sudo systemctl enable smbd
Запустим:
sudo systemctl start smbd
Проверим текущий статус:
sudo systemctl status smbd
```

Далее перечислим оставшиеся команды управления сервисом smbd. Они могут потребоваться в дальнейшем в процессе эксплуатации Samba.
Остановить сервис:
```bash
sudo systemctl stop smbd
Перезапуск демона:
sudo systemctl restart smbd
```

```bash
[Soft]
    comment = Public Folder
    path = /var/soft
    public = yes
    writable = yes
    read only = no
    guest ok = yes
    create mask = 0777
    directory mask = 0777
    force create mode = 0777
    force directory mode = 0777
nano /etc/avahi/avahi-daemon.conf
```

Убрать из автозапуска:
```bash
sudo systemctl disable smbd
```
Перечитать конфигурацию:
```bash
sudo systemctl reload smbd
```



