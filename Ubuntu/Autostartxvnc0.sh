.Autostartxvnc0.sh  имя должно быть такое.
#!/bin/sh

/usr/lib/sudo Xorg


service dbus restart > /dev/null; DISPLAY=:0 XDG_SESSION_TYPE=x11 gnome-session > /dev/null > /dev/null
/usr/bin/x11vnc -notruecolor -forever -display :0 -usepw
