#### Скачать свежую Fedora Linux, устанавливаем и разбираем нужные команды.
###### Разметка диска
Если разбиваем диск в ``btrfs`` то делаем чтобы было как то так
```python
@log /var/log
@home /home
@ /
```
###### Как примонтировать диск в систему
```python
mount /dev/sdXN /home/user/multimedia
```
Монтирование компакт-диска или DVD

Вставьте компакт-диск или диск DVD в дисковод и введите команду:
```python
mount -t iso9660 -o ro /dev/cdrom /cdrom
```
###### Ускоряем DNF
В терминале (CTRL+ALT+T) выполняем:
```python
sudo gnome-text-editor /etc/dnf/dnf.conf
```
и добавляем в конец файла следующие параметры:
```python
fastestmirror=True  
max_parallel_downloads=10
defaultyes=True
keepcache=True
```
> [!Warning]
> ``fastestmirror=True`` - dnf пытается подключаться к серверам Yandex, а какие-то пакеты там могут отсутствовать и поэтому могут сыпаться различные ошибки.

Далее выполняем:
```python
sudo dnf autoremove && sudo dnf clean all
```
Добавляем автоматическое обновление зеркал в фоне (по идеи должно ускорить dnf)
```python
sudo dnf install dnf-automatic
```
```python
sudo systemctl enable dnf-automatic.timer
```
###### Для обладателей твердотельных накопителей SSD
Открываем ``fstab`` командой в терминале (CTRL+ALT+T):
```python
sudo gnome-text-editor /etc/fstab
```
и добавляем данные параметры после этой строки ``compress=zstd:1``

```python
,defaults,noatime,discard=async
```

Для разделов: /, /home, /var/log

