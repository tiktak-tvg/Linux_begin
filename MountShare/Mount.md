#### Монтирование файловой системы NFS.

Проверим, что каталог экспортирован сервером NFS.

```
showmount -e имя-сервера
например
showmount -e 192.168.100.100
Export list for 192.168.100.100:
/data (everyone)
/ISO    (everyone)
/zbd   192.168.100.115
```

Создаём локальную точку монтирования командой ``mkdir``.
```
mkdir /mnt/iso
```
Далее подключим общую папку.

```
mount имя-сервера:/удаленный/каталог /локальный/каталог
например
mount.nfs 192.168.100.100:iso /mnt/iso
```
Если выйдет ошибка.

```
Command 'mount.nfs' not found, but can be installed with
надо установить пакет
apt install nfs-common
```

