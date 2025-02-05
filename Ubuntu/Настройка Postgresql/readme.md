##### Настройка postgresql-13

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

##### Установка PostgreSQL 16
```bash
1. Обновляем список пакетов и устанавливаем необходимые зависимости:

sudo apt update

 

sudo apt install -y apt-transport-https ca-certificates curl freetds-common freetds-dev g++ gcc git gnupg gnupg2 gpg libcurl4-openssl-dev libsybdb5 lsb-release make software-properties-common vim wget

2. Проверяем, версию в репозитории:

sudo apt policy postgresql

В случае, если версия PostgreSQL не соответствует актуальной, добавляем репозитории PostgreSQL:

curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

 

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

 

sudo apt update

3. Устанавливаем пакеты PostgreSQL:

sudo apt install -y postgresql-16 postgresql-server-dev-16 postgresql-client-16 postgresql-16-rum

Настройка сервера PostgreSQL 16

(Опционально) Перемещаем каталог данных PostgreSQL. В качестве нового каталога используем /pgdata. Вы указать другой, необходимый вам, каталог.

1. Создаем каталог /pgdata:

sudo mkdir /pgdata

2. Назначаем владельца на директории:

sudo chown -R postgres:postgres /pgdata

3. Останавливаем службу PostgreSQL:

sudo systemctl stop postgresql.service

4. Копируем файлы данных из каталога по умолчанию в новый каталог:

sudo cp -r -p /var/lib/postgresql/16/main/. /pgdata

Настройка postgresql.conf

В файле конфигурации '/etc/postgresql/16/main/postgresql.conf' редактируем следующие параметры:

data_directory = '/pgdata' # опционально

max_connections = 1500

listen_addresses = '*'

log_timezone = 'Europe/Moscow'

timezone = 'Europe/Moscow'

Настройка доступа к серверу PostgreSQL

Для настройки доступа к серверу PostgreSQL необходимо внести изменения в файлы конфигурации.

Настраиваем доступ к серверу PG. Для этого редактируем файл '/etc/postgresql/16/main/pg_hba.conf'

Для разрешения соединения только из указанной подсети:

host    all             all             192.168.4.0/24  md5

Для разрешения соединения из любой подсети:

host    all             all             0.0.0.0/0       md5

Настройка локализации

1. Устанавливаем локаль ru_RU.utf8:

sudo apt install -y language-pack-ru

sudo update-locale LANG=ru_RU.UTF-8

2. Проверяем командой locale. Должны получить следующее:

LANG=ru_RU.UTF-8

LANGUAGE=

LC_CTYPE="ru_RU.UTF-8"

LC_NUMERIC="ru_RU.UTF-8"

LC_TIME="ru_RU.UTF-8"

LC_COLLATE="ru_RU.UTF-8"

LC_MONETARY="ru_RU.UTF-8"

LC_MESSAGES="ru_RU.UTF-8"

LC_PAPER="ru_RU.UTF-8"

LC_NAME="ru_RU.UTF-8"

LC_ADDRESS="ru_RU.UTF-8"

LC_TELEPHONE="ru_RU.UTF-8"

LC_MEASUREMENT="ru_RU.UTF-8"

LC_IDENTIFICATION="ru_RU.UTF-8"

LC_ALL=

3. Настраиваем формат даты и времени. Создаем файл '/etc/freetds/locales.conf' со следующим наполнением:

sudo vim /etc/freetds/locales.conf

 

[default]

 date format = %b %e %Y %I:%M:%S.%z%p

4. Проверяем командой date. Должны получить дату в следующем формате:

Вт 09 мая 2023 22:16:05 UTC

Перезапуск службы PostgreSQL. Проверка статуса

1. Для перезапуска службы выполним следующую команду:

sudo systemctl restart postgresql.service

2. Проверим статус:

sudo systemctl status postgresql.service

sudo systemctl status postgresql@16-main.service

Настройка расширений

1. Для использования баз данных "Первой Формф" в PostgreSQL должны быть настроены следующие расширения:

•http

•pg_buffercache

•pg_hint_plan

•pgcrypto

•postgres_fdw

•rum

•tds_fdw

1. Скачиваем с GitHub исходники модуля **tds_fdw**, компилируем и устанавливаем:

git clone https://github.com/tds-fdw/tds_fdw.git

cd tds_fdw

make USE_PGXS=1

sudo make USE_PGXS=1 install

cd

2. Скачиваем с GitHub исходники модуля **pg_hint_plan**, компилируем и устанавливаем:

git clone https://github.com/ossc-db/pg_hint_plan.git

cd pg_hint_plan

git checkout PG16

make

sudo make install

cd

3. Скачиваем с GitHub исходники модуля **http**, компилируем и устанавливаем:

git clone https://github.com/pramsey/pgsql-http.git

cd pgsql-http

make

sudo make install

cd

4. Заходим в терминальный клиент Postgres:

sudo -u postgres psql

5. Активируем расширения:

LOAD 'pg_hint_plan';

CREATE EXTENSION IF NOT EXISTS tds_fdw schema public;

CREATE EXTENSION IF NOT EXISTS http schema public;

CREATE EXTENSION IF NOT EXISTS rum schema public;

CREATE EXTENSION IF NOT EXISTS postgres_fdw schema public;

CREATE EXTENSION IF NOT EXISTS pgcrypto schema public;

CREATE EXTENSION IF NOT EXISTS pg_buffercache schema public;

CREATE EXTENSION IF NOT EXISTS btree_gin;

Создание пользователей и баз данных

1. Заходим в терминальный клиент Postgres:

sudo -u postgres psql

2. Создаем пользователей:

create user dbo with superuser createdb createrole inherit login password 'PASSWORD';

create user d10taskuser with inherit login password 'PASSWORD';

create user migrationsdaemon with inherit login password 'PASSWORD';

create user rebus with inherit login password 'PASSWORD';

create user implementer with inherit login password 'PASSWORD';

Вместо PASSWORD пропишите пароли пользователей PostgreSQL.

3. Создаем базы данных d10task и taskfilesdb:

create database d10task

template template0

owner dbo

encoding 'utf8'

lc_collate 'ru_RU.utf8'

lc_ctype   'ru_RU.utf8';

 

create database taskfilesdb

template template0

owner dbo

encoding 'utf8'

lc_collate 'ru_RU.utf8'

lc_ctype   'ru_RU.utf8';

 

GRANT ALL PRIVILEGES ON DATABASE d10task TO d10taskuser;

GRANT ALL PRIVILEGES ON DATABASE taskfilesdb TO d10taskuser;

Выйти из консоли можно командой \q.

4. Создаем схему в базе taskfilesdb:

sudo -u postgres psql -d taskfilesdb

 

create extension if not exists tds_fdw schema public;

create schema if not exists dbo authorization dbo;

create table dbo.UploadFiles

(

 id              int not null  generated by default as identity,

 FileContent     bytea,

 Ext             varchar,

 UserID          int,

 FileName        varchar,

 Compressed      bool  constraint DF_UploadFiles_Compressed default false,

 

   constraint PK_UploadFiles primary key (id)

);

\q

5. Копируем на сервер файл с расширением dump, содержащий структуру и контент базы данных, в определенную папку, например: /src/d10task_hd.dump. Данный файл вам может предоставить техническая поддержка. Выполняем рестор 'pg_restore -d DB_NAME DB_DUMP' в созданную базу:

sudo su — postgres

pg_restore -d d10task /pgdata/backup/d10task-template.dump

6. Настраиваем схемы для пользователей в новой базе:

sudo -u postgres psql -d d10task

 

alter role D10TaskUser set search_path = "dbo", "public";

alter role dbo set search_path = "dbo", "public";

alter user MigrationsDaemon set search_path = "dbo", "public";

alter user rebus set search_path = "rebus", "public";

На этом настройка СУБД PostgreSQL 16 завершена.


# become the postgres user
sudo -i -u postgres

# open the postgres shell
psql

# create a void database with the name I want
create database "postgres-local";

# give privileges to the already-existing user postgres to access that database
grant all privileges on database "postgres-local" to postgres;

# set the password 'postgres' to user  'postgres'
ALTER USER postgres WITH PASSWORD 'postgres';
```


