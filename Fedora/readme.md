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
###### Меняем версию ядра
Устанавливаем утилиту grubby
```python
sudo dnf install grubby
```
Смотрим список доступных ядер в системе:
```python
sudo grubby --info=ALL | grep -E "^kernel|^index"
```
Получаем что-то похожее на это:
```python
index=0
kernel="/boot/vmlinuz-6.0.5-200.fc36.x86_64"
index=1
kernel="/boot/vmlinuz-5.19.16-301.fc37.x86_64"
index=2
kernel="/boot/vmlinuz-5.19.16-200.fc36.x86_64"
index=3
kernel="/boot/vmlinuz-0-rescue-e5e0486de0354ed5adbd9418f209953e"
```
Выбираем версию ядря, которую хотим использовать (выбрав нужный index из списка)
```python
sudo grubby --set-default-index=0
```
В примере выше я выбрал kernel 6.0 у которого index=0

Проверям всё ли применилось:

```python
sudo grubby --default-title
Перезагружаем ПК
```
###### Установка кодеков
```python
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia
```
###### Дополнительные настройки GNOME
```python
sudo dnf install gnome-tweaks
```
###### Включаем дробное масштабирование
```python
gsettings set org.gnome.mutter experimental-features "[‘scale-monitor-framebuffer’]"
```
###### Устанавливаем консольный софт
```python
sudo dnf install neofetch cpufetch inxi htop vim
```
###### Консольные команды для GNU/Linux

![image](https://github.com/user-attachments/assets/3dc80ec1-e574-426a-877e-f9ce9b5fcbf1)

###### Команды редактора VIM
```python
:e /название_файла               - открыть файл

:w                                             - записать изменения

:q                                              - закрыть редактор

:q!                                             - закрыть редактор игнорируя всё

:x                                              - записать измения и закрыть файл

Добавление ! знака к любой командe, значит выполнят её игнорируя все предупреждения. Например :q!

i                                                - вставка перед курсором

o                                               - создать новую строку под курсором

p                                               - вставить после курсора

dd                                             - удалить строку

$                                                - End На конец строки

0 - (ноль)                                 - На начало строки

Copy
<Ctrl-f> - на страницу (экран) вниз;
<Ctrl-b> - на страницу (экран) верх;
<Ctrl-d> - на пол страницы (экрана) вниз;
<Ctrl-u> - на пол страницы (экрана) верх;
<Ctrl-y> - на строку вверх, без изменения положения курсора;
<Ctrl-e> - на строку вних, без изменения положения курсора;
split /название_файла           - отрыть другой файл с горизонтальным разделением

vsplit /название_файла         - отрыть другой файл с вертикальным разделением

ctrl+w ctrl+w                          - переключение между активными окнами редактора

v                                                - Войти в режим выделения символов

V                                               - Войти в режим выделения строк

Control+Shift+v                      - Войти в режим выделения прямоугольного блока текста

u                                                - Изменить регистр выделенных символов на нижний

U                                               - Изменить регистр выделенных символов на верхний

~                                               - Изменить регистр выделенных символов на противоположный

/                                                 - Войти в режим ввода выражения для поиска.

:noh                                           - Выйти из режима поиска,выключит подсветку найденого.
```






