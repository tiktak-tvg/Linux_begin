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

Переходи на веб страницу и заходим на виртуальную машину.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/a511ed49-90af-4abd-93f5-70b93680ffe9)

Открываем терминал и запускаем команду для скачивания плагина ``VBoxLinuxAdditions``.

```
wget https://download.virtualbox.org/virtualbox/6.1.30/VBoxGuestAdditions_6.1.30.iso -P /tmp
```

Далее монтируем скаченное в ``/mnt``

```
mount -o loop /tmp/VBoxGuestAdditions_6.1.30.iso /mnt
```
И запускаем скрипт из этой папки.

```
sh /mnt/VBoxLinuxAdditions.run
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/4e6a010c-c6bc-4971-9e1c-003341334b60)

Готово!!!

Ну как по мне, лучше пользоваться ``cockpit`` или ``putty`` или ``mobaXterm``. На самой виртуалке, если только ставить эксперименты с сетью.

