#### Установка контролера домена ALD PRO.
##### Предварительная подготовка сервера.

Проверяем на рекомендуемое соответствие.
```bash
cat /etc/astra/build_version
sudo astra-modeswitch getname
sudo astra-modeswitch list
Если режим другой, то выбирайте нужный
sudo astra-modeswitch set 2 
```
Добавим и запустить службу синхронизации времени chrony в автозапуск.
```bash
sudo systemctl status chrony
если не установлена, установить можно так
sudo apt install chrony
sudo systemctl start chrony
sudo systemctl enable chrony
```
Добавим Российские NTP сервера и можно указать разрешённую сеть для клиентов.
Вводим ``nano /etc/chrony/chrony.conf`` и добавляем эти строки
```bash
server 0.ru.pool.ntp.org iburst
server 1.ru.pool.ntp.org iburst
server 2.ru.pool.ntp.org iburst
server 3.ru.pool.ntp.org iburst
allow 192.168.25.0/24
```
После настройки сервера нужно перезапустить службу: ``sudo systemctl restart chrony``

Проверим источники времени:``sudo chronyc -N sources``

Проверим порт. Сервер времени chrony, также как и другие NTP сервера слушает порт udp 123: ``sudo ss -ulpn | grep chronyd``

Можем посмотреть количество активных и не активных источников: ``sudo chronyc activity``

>[Warning]
>Теперь нужно, на остальных серверах, прописать наш сервер Chrony в качестве источника синхронизации времени.
>Для этого укажем его адрес в ``/etc/systemd/timesyncd.conf`` на остальных серверах. А затем перезапустим службу синхронизации времени
```bash
[Time]
NTP=192.168.25.112
```
При необходимости увеличить таймайт запроса проля sudo.(не обязательно) 
Допишите в конце строки через запятую следующую опцию timestamp_timeout=x. Должно получиться так:
```bash
Defaults env_reset, timestamp_timeout=30
```








Установка ALD Pro.
