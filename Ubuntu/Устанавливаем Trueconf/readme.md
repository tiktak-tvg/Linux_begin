Переходим  

  ``cd ~/Загрузка/``

Скачиваем

    wget -c http://trueconf.ru/download/trueconf-client-i386.deb
    
или

    wget -c http://trueconf.ru/download/trueconf-client-amd64.deb

Установка:
```bash
    dpkg -i trueconf-client-i386.deb
или
    dpkg -i trueconf-client-amd64.deb
```

Запуск ``Trueconf``	

Альтернативный способ установки

Переходим  

  ``cd ~/Загрузка/``

Скачиваем

    wget -c http://trueconf.ru/download/trueconf-client-amd64.deb

Используя учетную запись администратора, нужно запустить команду для скачанного пакета.
```bash
sudo -i
dpkg -i trueconf-client-amd64.deb
Для разрешения зависимостей воспользуйтесь командой:
apt-get -f install
```

Создайте файл /etc/apt/sources.list.d/trueconf.list с записью внутри:

  ``deb http://deb.trueconf.com/ubuntu bionic non-free # Это для Ubuntu 18.04``

С помощью учетной записи администратора запустите команды:
```bash
sudo -i
curl http://deb.trueconf.com/client/packages.trueconf.key | apt-key add -
apt-get update
apt-get install trueconf
exit
```

Запуск из командной строки

    Trueconf







