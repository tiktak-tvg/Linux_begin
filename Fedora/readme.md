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

###### Обновление системы
Для полного обновления системы выполняем команду в терминале (CTRL+ALT+T):
```python
sudo dnf upgrade --refresh
```
###### Как обновиться уже сейчас с Fedora 37 (в будущем просто меняем на 38/39 и т.д.):
```python
sudo dnf makecache --refresh && sudo dnf upgrade --refresh
sudo dnf autoremove && sudo dnf clean all
sudo dnf install dnf-plugin-system-upgrade -y
sudo dnf system-upgrade download --releasever=38
sudo dnf system-upgrade reboot

Если метод выше не работает или есть ошибки:

sudo dnf system-upgrade download --releasever=38 --allowerasing --skip-broken
sudo dnf system-upgrade reboot
sudo dnf system-upgrade clean

Если же и --allowerasing не работает, то пробуем:

sudo dnf distro-sync
sudo fixfiles -B onboot
```







