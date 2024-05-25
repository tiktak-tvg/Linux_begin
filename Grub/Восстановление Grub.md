##### Grub.

Список доступных ядер можно посмотреть например вот такой командой.<br> 
```
grub> ls /boot | grep vmlinuz
vmlinuz-5.3.0-45-generic
vmlinuz-5.3.0-46-generic
```

P.s. Если нет таких файлов значит их нет и восстановить их можно только с помощью копирования..<br>
Скачать файлы с рабочего компьютера из папки /boot/.<br>
```
config-5.3.0-45-generic
config-5.3.0-46-generic
initrd.img-5.3.0-45-generic
initrd.img-5.3.0-46-generic
System.map-5.3.0-45-generic
System.map-5.3.0-46-generic
vmlinuz-5.3.0-45-generic
vmlinuz-5.3.0-46-generic
```

Копируем в папку ``/boot/`` на не рабочем компьютере.<br>
из папки ``/boot/grub/ файл grub.cfg``
Замена ``grub.cfg`` в ``/boot/grub/grub.cfg`` на не рабочем компьютере.<br>
P.s. Если загрузочные ядро существует, тогда выполняем эти команды.<br>
Отображаем какие диски.<br>
```
grub> ls

grub> set root=(hd0,1) или set root=(hd0,gpt2)
grub> insmod part_gpt
grub> insmod ext2
grub> insmod normal
grub> normal

grub> linux /boot/vmlinuz-5.3.0-45-generic
```

Указываем корневой раздел и выполняем команду ( указывается тот же корневой раздел, что и в команде set root, только уже в классическом формате).<br>
```
grub> linux /boot/vmlinuz-5.3.0-45-generic root=/dev/sda2
```

Далее, нужно указать соответствующий образ ядра. В котором содержится всё необходимое для инициализации и создания программной среды для его работы, с помощью команды initrd:<br>
```
grub> initrd /boot/initrd.img-4.18.0-21-generic
```
Теперь всё готово, можно выполнить загрузку:<br>
```
grub> boot
```

основной набор команд, хранящихся в файле /boot/grub/grub.cfg и выполняемых GRUB автоматически.<br>
```
grub> nano /boot/grub/grub.cfg
```


