#### Увеличение диского пространства на OS Ubuntu/Debian.
>- df -H выводит список дисков
>- lsblk	вывод списка блочных устройств
>- fdisk -l	просмотр разделов диска
>- apt -y install cloud-guest-utils	установка утилиты growpart для Ubuntu, Debian
>- growpart /dev/sda 2	расширение раздела /dev/sda2
>- pvresize /dev/sda2	расширение существующего физического тома /dev/sda2
>- df -hT	вывод списка разделов, файловых систем
>- resize2fs /dev/sda? сообщает ядру, что таблица разделов поменялась
>- resize2fs /dev/mapper/ubuntu-root	увеличение размера файловой системы EXT4 на логическом томе /dev/mapper/ubuntu-root (для Ubuntu, Debian)

#### Увеличение диского пространства можно сделать через разные утилиты parted,growpart,fdisk,cfdisk.

> Выключаем виртуальную машину и расширяем диск с помощью ``Менеджер виртуальных дисков``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/906dde16-0772-4c93-b651-092d00f96c51)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/44c6d6c7-dfdb-484d-aac4-2715162fb1b7)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/fb2a3cda-6301-4568-93b6-fd7a308d033c)


> Запускаем виртуальную машину.

##### Увеличение диского пространства c помощью parted
> Выполнякем команды.

- ``` df -hT ```
- ``` lsblk ```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/375130bd-8920-46b0-af47-e05a539d87e4)
  
Это чтобы потом сверить показатели, сейчас нашего добавленного пространства нет. Теперь в дело вступает утилита parted.

###### P.s. ```При просто "su" не меняются переменные окружения. а при "su -" меняются. Корректнее пользоваться "su -"```
> Выполнякем команды.
- ``` parted /dev/sda print free ```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/2496663b-99fa-4995-8e39-75b8e80eacbf)
  
> Выведем всё в байтах.
- ``` parted /dev/sda unit B print free ```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/c880a641-1037-4c7e-9a33-8e59fd031478)

Нам нужна последняя цифра из свободного пространства, чтобы добавить к диску sda 3.

> Выполнякем команду.
- ``` parted /dev/sda unit B resizepart 3  107374165503B ```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/399a5c34-49f3-460e-a711-8b3a8ca6e8c5)

> Выполнякем команду.
 - ``` parted /dev/sda unit B print free и parted /dev/sda print free ``` 

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/05c3cd48-f4f8-4ce7-bfc9-2521e27ef759)

> Смотрим ``df -hT``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/aa080791-6f79-441e-a701-f1788e6b66c3)

> Теперь надо ядру сообщить, что таблица разделов поменялась. Иначе команда ``df -hT`` будет не правильно показывать пространство.
- ``` resize2fs /dev/sda3 ```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/e27f0dc2-dcbf-45b7-bfeb-6855573f5824)
  
Если даннные не обновились после команды ``df -hT``, перезагружаем компьютер и ещё раз ``` resize2fs /dev/sda3 ```



![image](https://github.com/user-attachments/assets/388ad8ac-c2e2-453e-9865-d7a6888c95fd)

