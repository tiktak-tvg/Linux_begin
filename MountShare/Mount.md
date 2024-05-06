#### Монтирование файловой системы NFS в Linux.

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
После установки опять попробовать подключиться.

```
mount.nfs 192.168.100.100:iso /mnt/iso
```

Проверяем подключилась ли общая папка.

```
ls /mnt/iso
```
![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/b21046c7-cf40-44d3-a3e8-888fcde8d5d5)

#### Как подключить NFS каталог в Windows 10.

Для начала включим необходимые компоненты Windows.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/a790f7c1-50ec-401c-a601-1e52e68a8792)

Далее открываем консоль cmd и прописываем следующие команды.

> Для начала посмотрим какие папки доступны и которая нам нужна.
  - ``showmount -e 192.168.10.x``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/1bedde4c-59b6-4063-a6f5-9f0af09fac4c)

  - далее, команду подключения диска
      
```  mount -o anon \\192.168.10.x\iso X: ```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/81106d99-5363-458e-9e08-25fc28dc7fa3)

