```bash
nano /etc/systemd/logind.conf
RemoveIPC=no

Слишком маленькое значение может убить процесс
sysctl -w vm.swappines=10
sysctl -w vm.overcommit_memory=2
Отвечает за процесс сброса грязных страниц, выполняющихся с блокировкой приложения(в рабочем сеансе)
sysctl -w vm.dirty_ratio=10
Процент памяти, занятый грязными страницами, который необходимо сбросить на диск
sysctl -w vm.dirty_background_ratio=3

По умолчанию размерстраниц в ОС равен 4Кб
Если памяти много, то лучше сделать 2Мб

autovacuum_max_workers: общее количество ядер/2
для 1С
autovacuum_vacuum_scale_factor:5% 
& 
autovacuum_analyze_dcale_factor:5%

autovacuum_vacuum_cost_limit:
&
autovacuum_vacuum_cost_delay:

shared_buffers: не более 50% 1/4 от общего объема памяти
maintenance_work_mem:32-128МБ
work_mem: 32-128МБ
temp_buffers:128МБ
max_locks_per_transaction >= 150


При начальной настройке, чтобы зайти пользователем postgres, должно быть так
nano /var/lib/pgsql/data/pg_hba.conf
# IPv4 local connections:
host    all     all     127.0.0.1/32      trust
# IPv6 local connections:
host    all     all     ::1/128           trust


/etc/init.d/postgresql restart
После этого можно подключиться к серверу для создания нужных баз данных и пользователей:

psql -U postgres -h localhost
или
sudo -u postgres psql
ALTER USER postgres WITH PASSWORD 'postgres';

добавляем подключение для всех
nano /var/lib/pgsql/data/postgresql.conf
listen_addresses = '*'
После редактирования файла необходимо перезагрузить сервер:
systemctl restart postgresql

psql -U my_login -h 10.0.0.101 postgres

netstat -pant | grep postgres

nano /var/lib/pgsql/data/pg_hba.conf
```
