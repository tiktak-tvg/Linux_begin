#### Как увеличить LVM раздел в OS CentOS.
Для начала смотрим, что у нас с разделами:
```bash
# fdisk -l
```
Диск /dev/sda: 21.5 ГБ, 21474849357 байт
```bash
Устр-во   Загр     Начало       Конец       Блоки   Id  Система
/dev/sda1   *           1          64      512000   83  Linux
/dev/sda2              64         653     4729856   8e  Linux LVM
/dev/sda3             653        1305     5239532+  8e  Linux LVM
```
Видим что место в логическом томе не увеличилось, вот это и решаем:
```bash
# df -h
```
Файловая система      Разм  Исп  Дост  Исп% смонтирована на
```bash
/dev/mapper/vt_t-lv_root
                      7,5G  2,5G  4,7G  35% /
tmpfs                 504M     0  504M   0% /dev/shm
/dev/sda1             485M   49M  412M  11% /boot
```
Запоминаем названия:  vt_t и имя тома lv_root., в вашем случае имена другие.

Видим что у нас имеется неразмеченная область. Создадим новый раздел sda4 с типом раздела Linux LVM (код типа 8e) на этой области. Для этого работаем с устройством с меткой sda:
```bash
# fdisk /dev/sda
```
>[!WARNING:] DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Справка: команды оболочки fdisk

a     переключение флага загрузки
b     редактирование метки диска bsd
c     переключение флага dos-совместимости
d     удаление раздела
l     список известных типов файловых систем
m     вывод этого меню
n     добавление нового раздела
o     создание новой пустой таблицы разделов DOS
p     вывод таблицы разделов
q     выход без сохранения изменений
s     создание новой чистой метки диска Sun
t     изменение id системы раздела
u     изменение единиц измерения экрана/содержимого
v     проверка таблицы разделов
w     запись таблицы разделов на диск и выход
x     дополнительная функциональность (только для экспертов)

Далее используем следующие команды:

n — создаём новый раздел;
p — обозначаем его как primary;
так как у нас было 3 логических раздела, то на вопрос Partition number (1-4) отвечаем 4;
t — укажем тип раздела;
опять тот же вопрос Partition number (1-4), отвечаем 4;
вводим 8e — это код типа раздела, соответствующий Linux LVM;
убедимся, что всё сделано верно, вводим p — показать таблицу разделов:

Команда (m для справки): n
Действие команды
   e   расширенный
   p   основной раздел (1-4)
p
Выбранный раздел 4
Первый цилиндр (1306-2610, по умолчанию 1306):
Используется значение по умолчанию 1306
Last цилиндр, +цилиндры or +size{K,M,G} (1306-2610, по умолчанию 2610):
Используется значение по умолчанию 2610

Команда (m для справки): t
Номер раздела (1-4): 4
Шестнадцатеричный код (введите L для получения списка кодов): 8e
Системный тип раздела 4 изменен на 8e (Linux LVM)

Команда (m для справки): p
```bash
Устр-во Загр     Начало       Конец       Блоки   Id  Система
/dev/sda1   *           1          64      512000   83  Linux
/dev/sda2              64         653     4729856   8e  Linux LVM
/dev/sda3             653        1305     5239532+  8e  Linux LVM
/dev/sda4            1306        2610    10482412+  8e  Linux LVM
```
Раздел sda4 создан. Вводим w для сохранения изменения на диске. Перезагружаемся.

Далее создаем физический том sda4:
```bash
# pvcreate /dev/sda4
  Physical volume "/dev/sda4" successfully created
```
Далее расширяем группу томов, на новое пространство. Используем наше имя группы томов vt_t, которое мы запомнили командой df выше:
```bash
# vgextend /dev/vt_t /dev/sda4
  Volume group "vt_t" successfully extended
```
далее расширим логический том:
```bash
# lvextend -l+100%FREE /dev/vt_t/lv_root
  Extending logical volume lv_root to 17,5 GiB
  Logical volume lv_root successfully resized
```
Активация:
```bash
# vgscan
  Reading all physical volumes.  This may take a while...
  Found volume group "vt_t" using metadata type lvm2
```
```bash
# vgchange -ay
  2 logical volume(s) in volume group "vt_t" now active
```
В заключении — расширяем файловую систему утилитой resize2fs:
```bash
# resize2fs /dev/vt_t/lv_root
resize2fs 1.41.12 (17-May-2010)
Filesystem at /dev/vt_t/lv_root is mounted on /; on-line resizing required
old desc_blocks = 1, new_desc_blocks = 2
Performing an on-line resize of /dev/vt_t/lv_root to 4593665 (4k) blocks.
The filesystem on /dev/vt_t/lv_root is now 4593665 blocks long.
```
Информация: Для CentOS с файловой системой xfs используйте xfs_growfs вместо resize2fs. Данная процедура может занять некоторе время! Проверяем:
```bash
# df -h
```
Файловая система      Разм  Исп  Дост  Исп% смонтирована на
```bash
/dev/mapper/vt_t-lv_root
                       18G  2,5G   14G  15% /
tmpfs                 504M     0  504M   0% /dev/shm
/dev/sda1             485M   49M  412M  11% /boot
```


