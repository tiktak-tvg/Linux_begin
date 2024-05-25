```
# Состояние службы
sudo systemctl status cups

# Запускаем службу
sudo systemctl start cups.service

# Остановить службу 
sudo systemctl stop cups

# Если ошибка ДОСТУП ЗАПРЕЩЕН через подключение по web интерфейсу localhost:631
# Открыть терминал и написать две строки:		
sudo cupsctl WebInterface=Yes
sudo cupsctl FileDevice=Yes

# перезапуск службы cups
sudo /etc/init.d/cups restart
sudo /etc/init.d/cups-browsed restart


# проверка на ошибки службы cupsd
cupsd -t   #cupsd -h

# добавить службу в автозагрузку
sudo systemctl enable cups


# Посмотреть разрешена ли сейчас автозагрзука для службы cups
sudo systemctl is-enabled cups 

# Проверка доступности USB принтера
lsusb
lsmod | grep usb

# Редактируем cupsd.conf
sudo gedit /etc/cups/cupsd.conf



```
