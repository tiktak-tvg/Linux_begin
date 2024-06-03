
```
# apt install lxde
```

```
# sudo apt install xrdp
```

Настройки сервера хранятся в файле /etc/xrdp/sesman.ini. Некоторые настройки сервера установленные по умолчанию:

- AllowRootLogin=true — авторизация Root;
- MaxLoginRetry=4 — максимальное количество попыток подключения;
- TerminalServerUsers=tsusers — группа, в которую необходимо добавить пользователей для организации доступа к серверу;
- MaxSessions=50 — максимальное количество подключений к серверу;
- KillDisconnected=false — разрыв сеанса при отключении пользователя;
- FuseMountName=Mount_FOLDER — название монтируемой папки.

*По умолчанию для подключения по RDP используется порт 3389. Номер порта можно изменить в файле /etc/xrdp/xrdp.ini.*

```
# nano /etc/xrdp/startwm.sh
```

```
# debian, alt
#  if [ -r /etc/X11/Xsession ]; then
#    pre_start

#   . /etc/X11/Xsession
#   post_start
#   exit 0
# fi
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/10b8ff5c-16a7-425d-880b-1c6d04d3bbd4)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ada6b271-7a04-4ba4-b7f8-f253f98dd2bd)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/2b3860b0-5ca3-4c08-ba2e-54c9e76d8540)

```
lxsession -s LXDE -e LXDE
```

Установить пакет xrdp:

```
# apt-get install xrdp
```
Включить и добавить в автозапуск сервисы:

```
# systemctl enable --now xrdp xrdp-sesman
```

Права доступа пользователя:

Для доступа к терминальному сеансу — включить в группу tsusers:

```
# gpasswd -a user tsusers
```

Для проброса папки — включить в группу fuse:

```
# gpasswd -a user fuse
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/e9fae79f-6d2a-48ef-8e16-4fb749298e76)

Для подключения можно использовать FreeRDP — клиент для подключения к удаленному рабочему столу по протоколу RDP.

Установить пакет xfreerdp:

```
# apt-get install xfreerdp
```

Описание некоторых параметров:

/v:<сервер>[:порт] — IP-адрес или имя сервера;
/u:<пользователь> — имя пользователя;
/p:<пароль> — пароль пользователя;
/w:<ширина> — ширина окна;
/h:<высота> — высота окна;
/f — полноэкранный режим;
/size:<ширина>x<высота> — размер окна;
/drive:<название>,<путь> — подключение каталога.

xfreerdp /drive:Epson,/home/cas/epson /v:10.4.129.129 /u:user /p:123

где:

- Epson — название папки, которая будет показываться в каталоге thinclient_drives в домашней папке терминального пользователя, у локального пользователя пробрасывается папка /home/cas/epson;
- 10.4.129.129 — адрес терминального сервера;
- user — имя терминального пользователя;
- 123 — пароль терминального пользователя.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/12c4092b-76fc-42ee-a98d-6392a306448d)




