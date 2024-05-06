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

Команда для проверки, имеется ли уже установленный NFS-клиент.
> Для ОС Debian или Ubuntu:
``` 
dpkg -l nfs-common
```
> Для ОС CentOS или Red Hat:

```
rpm -qa|grep nfs
```

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
> Например.
  - ``showmount -e 192.168.10.27``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/1bedde4c-59b6-4063-a6f5-9f0af09fac4c)

  - далее, команду подключения диска
      
```  mount -o anon \\192.168.10.27\iso X: ```

где X это любой свободный виртуальный диск.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/81106d99-5363-458e-9e08-25fc28dc7fa3)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ceb66d0f-be6a-49a5-b36e-2796b864bfab)

Далее, можно настроить права и доступ на выполнение.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/1463bae2-d291-4086-8533-3479753ecd23)

#### Подключение файловых систем NFS с помощью /etc/fstab

``` 192.168.10.27:/iso    /mnt/iso   nfs    rsize=8192,wsize=8192,timeo=14,intr```

#### NFS поверх TCP.

При подключении экспортированной файловой системы NFS на клиентском компьютере передайте параметр ``-o udp`` команде ``mount``.

mount -o udp 192.168.10.27:/iso /mnt/iso

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/d6c87371-1a7c-4197-8b9d-590c7bf132b0)


