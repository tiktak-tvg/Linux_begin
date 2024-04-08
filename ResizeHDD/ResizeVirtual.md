#### Увеличение диского пространства на OS Ubuntu/Debian.
>- lsblk	вывод списка блочных устройств
>- pvs	вывод списка физических томов  `` pvs -a | требуется пакет apt install lvm2 ``
>- vgs	вывод списка группы томов
>- lvs	вывод списка логических томов
>- fdisk -l	просмотр разделов диска
apt -y install cloud-guest-utils	установка утилиты growpart для Ubuntu, Debian
growpart /dev/sda 2	расширение раздела /dev/sda2
pvresize /dev/sda2	расширение существующего физического тома /dev/sda2
lvextend -r -l +100%FREE /dev/centos/root	расширение логического тома /dev/centos/root из группы томов centos
df -hT	вывод списка разделов и файловых систем
xfs_growfs /dev/mapper/centos-root	увеличение размера файловой системы XFS на логическом томе /dev/mapper/centos-root (для Fedora, CentOS, RHEL, Oracle Linux, Alma Linux, Rocky Linux)
resize2fs /dev/mapper/ubuntu-root	увеличение размера файловой системы EXT4 на логическом томе /dev/mapper/ubuntu-root (для Ubuntu, Debian)
