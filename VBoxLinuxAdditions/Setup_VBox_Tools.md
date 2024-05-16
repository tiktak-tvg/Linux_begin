#### Устанавливаем на VirtualBox утилиту VBoxLinuxAdditions.

Устанавливаем для начала ``cockpit``.

```
yum install cockpit или dnf install cockpit
далее определяем его статус
systemctl status cockpit.socket
```
![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ea217304-bffa-44c9-b10c-97ff7d77c6e9)

```
запускаем службу
systemctl start cockpit.socket
установим запуск при старте
systemctl enable cockpit.socket
```

добавим порт для подключения в файервол

```
firewall-cmd --add-port=9090/tcp
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/259e7c52-0ab5-4011-8500-ea78218e0abf)
