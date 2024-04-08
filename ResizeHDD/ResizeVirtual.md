#### Увеличение диского пространства на OS Ubuntu/Debian.

>- lsblk	вывод списка блочных устройств
>- pvs	вывод списка физических томов  `` pvs -a | требуется пакет apt install lvm2 ``
>- vgs	выдает форматированный вывод о группах томов 
>- lvs	вывод списка логических томов
>- fdisk -l	просмотр разделов диска
>- apt -y install cloud-guest-utils	установка утилиты growpart для Ubuntu, Debian
>- growpart /dev/sda 2	расширение раздела /dev/sda2
>- pvresize /dev/sda2	расширение существующего физического тома /dev/sda2
>- df -hT	вывод списка разделов и файловых систем
>- resize2fs /dev/mapper/ubuntu-root	увеличение размера файловой системы EXT4 на логическом томе /dev/mapper/ubuntu-root (для Ubuntu, Debian)

#### Увеличение диского пространства можно сделать через разные утилиты parted,growpart,fdisk,cfdisk.

> Выключаем виртуальную машину и расширяем диск с помощью ``Менеджер виртуальных дисков``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/906dde16-0772-4c93-b651-092d00f96c51)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/44c6d6c7-dfdb-484d-aac4-2715162fb1b7)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/fb2a3cda-6301-4568-93b6-fd7a308d033c)


> Запускаем виртуальную машину.

##### Увеличение диского пространства c помощью parted
> Выполнякм команды.

- ``` df -hT ```
- ``` lsblk ```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/375130bd-8920-46b0-af47-e05a539d87e4)
  
Это чтобы потом сверить показатели, сейчас нашего добавленного пространства нет.

  
