### Как починить загрузку системы
<img width="721" height="399" alt="image" src="https://github.com/user-attachments/assets/af89187a-c521-4348-85b8-25bfa55199d2" />

Для начала – попробуйте загрузиться вручную из grub rescue

В режиме ``rescue`` доступен только ограниченный набор команд: ``ls, set, insmod, linux, initrd, boot``.

#### Шаг 1. Посмотрите доступные диски и разделы
Введите:
```text
ls
```
Вы увидите что-то вроде (hd0) (hd0,msdos1) (hd0,msdos2) или (hd0,gpt1) (hd0,gpt2).

#### Шаг 2. Найдите раздел с файлами /boot/grub
По очереди пробуйте:
```text
ls (hd0,1)/
ls (hd0,2)/
ls (hd0,msdos1)/
```
Если видите папки grub или boot, то это ваш системный раздел (или загрузочный). Допустим, это (hd0,msdos1).

#### Шаг 3. Укажите GRUB правильные параметры
```text
set prefix=(hd0,msdos1)/boot/grub
set root=(hd0,msdos1)
insmod normal
normal
```
> - Если insmod normal не работает (ошибка unknown filesystem), попробуйте сначала загрузить модуль для файловой системы, например:

```text
insmod ext2
```
(если у вас ext4 – подойдёт ext2).

После normal вы должны попасть в обычное меню GRUB. Если нет – переходите к следующему шагу.

#### Шаг 4. Загрузите Linux напрямую (если normal не запускается)
Найдите ядро и initrd:
```text
ls (hd0,msdos1)/boot/
```
Ищите файлы, похожие на ``vmlinuz-...`` и ``initrd.img-....`` Затем введите:
```text
linux (hd0,msdos1)/boot/vmlinuz-5.15.0-100-generic root=/dev/sda1 ro
initrd (hd0,msdos1)/boot/initrd.img-5.15.0-100-generic
boot
```
> - (Замените пути и версию ядра на свои, а sda1 – на соответствующий раздел, например hd0,msdos1 – это может быть /dev/sda1).

####  Если ничего не помогло – загрузитесь с Live USB и восстановите GRUB
Режим unknown filesystem часто означает, что GRUB не узнаёт файловую систему раздела (например, из-за сбоя, изменения разделов или повреждения суперблока).

Что делать:

Загрузитесь с установочной флешки Linux (в режиме «Live», «Попробовать без установки»).

Откройте терминал.

Узнайте, какой раздел является корневым:
```text
sudo fdisk -l
sudo blkid
```
Найдите раздел с типом ext4 или btrfs, обычно это /dev/sda2, /dev/sda3 и т.д.

Примонтируйте его (например, /dev/sda2):
```text
sudo mount /dev/sda2 /mnt
```
Если /boot на отдельном разделе – примонтируйте и его.

Переустановите GRUB:

Для BIOS/legacy:
```text
sudo grub-install --root-directory=/mnt /dev/sda
```
Для UEFI:
```text
sudo mount /dev/sda1 /mnt/boot/efi   # обычно EFI раздел
sudo grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --boot-directory=/mnt/boot
```
Обновите конфигурацию:
```text
sudo update-grub --output=/mnt/boot/grub/grub.cfg
```
Перезагрузитесь, сняв флешку.

#### Для полного выхода из GRUB (если он не нужен)
Если вы хотите не чинить GRUB, а переключиться на другой загрузчик (например, Windows Boot Manager), то после загрузки с Live USB можно просто удалить GRUB с диска:

Для UEFI: удалить папку ```/boot/efi/EFI/ubuntu (или где у вас GRUB)`` и через ``efibootmgr`` изменить порядок загрузки.

Для BIOS: перезаписать MBR командой sudo ``dd if=/dev/zero of=/dev/sda bs=446 count=1`` (осторожно! Это удалит загрузчик полностью).

Но проще всего – войти в ``BIOS/UEFI (клавишами F2/Del при старте)`` и поставить в загрузке первым ``Windows Boot Manager``, если система двойная.

> - Главный вывод: из grub rescue нет команды, которая просто вернёт вас в меню. Нужно либо вручную загрузиться (команды выше), либо восстановить загрузчик с Live USB. 

