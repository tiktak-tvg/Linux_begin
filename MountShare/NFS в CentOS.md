#### Реализацию NFS в CentOS 7.

Для начала установим пакет ``nfs`` на две машины. У меня одна виртуалка называется ``cent1``, другая ``cent2``.<br>
Сервер ``nfs`` будем ставить на ``cent1``, подключаться с ``cent2``.<br>
Так как у меня DNS не настроет, подключение будет по IP адресу.<br>

Устанавливаем пакет на две виртуальные машины.

```
yum install nfs-utils
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/f7db2615-6fa6-4397-8883-d4e702e46c3d)

Проверяем, что всё установилось, только не запущено.

```
systemctl status {nfs,rpcbind,nfslock}
systemctl status nfs-server
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/a94d051b-ba75-4418-af81-b51f3eb69094)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/9335e9f1-4a11-48d6-a185-3922660c9a82)

Далее, запускаем сервер.

```
systemctl start nfs-server
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/7ccc11fb-9734-4ac7-abb2-ce21f8e19e65)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/484f6dfc-2469-47ef-8bf3-1a810f924b90)

Теперь, создаём каталог, сделаем файл с надписью ``Hello, NFS!``.

```
mkdir /var/nfs/export01 -p
echo 'Hello, NFS!' > /var/nfs/export01/file.txt
cat /var/nfs/export01/file.txt
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/4e1ed825-4f59-42f7-8ed7-a7e7ccd21fb0)

Редактируем файл подключения.<br>
Eсли настроен dns можно прописать имя компьютера с которого будем подключаться ``cent2.local``. <br>
```
nano /etc/exports
/var/nfs/export01   192.168.85.138 
```

Проверяем.
```
exportfs
exportfs -a
exportfs -v
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/e4947762-6629-4b95-9fc8-026bfd6cf5b7)

Осталось малое, включить службу в файерволе.

```
firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload
iptables-save
```

Проверяем еще раз.

```
exportfs
exportfs -v
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ea5cf174-a55a-420d-98dd-bbd69c2b496a)

Переходим на вторую виртуальную машину ``cent2``. Монтируем диск ``/mnt`` с удаленной машины 

```
mount 192.168.85.139:/var/nfs/export01 /mnt
df -h   смотрим внизу должен появиться смонтированный диск.
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/6dbd3a42-c92e-4270-9ece-40c982062e3c)

Проверяем, что у нас есть доступ к созданному файле на виртуальной машине ``cent1`` и смотрим поледнее, что было примонтированно.

```
cat /mnt/file.txt
[root@cent2 sol]# cat /mnt/file.txt
Hello, NFS!
[root@cent2 sol]# mount | tail -n1
192.168.85.139:/var/nfs/export01 on /mnt type nfs4 (rw,relatime,vers=4.1,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.85.138,local_lock=none,addr=192.168.85.139)
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/c52a5be2-9d26-4555-8d8c-7d3c53dc5ce5)

По поиску ищем список модуля ядра и какие процессы на данный момент запущены по ``nfs``.

```
lsmod | grep nfs
ps -A | grep nfs
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/3db34e57-2750-432c-a055-6732e4d9c16a)

Подключение настроено.










