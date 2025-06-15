#### Установка Корпоративного сервера 2024 offline-версии для ОС Astra.

Установка произваодится на VM Ware Workstation, версия ОС Астра 1.7.4

Установка состоит из двух этапов:

1. Предварительная подготовка.
2. Установка Корпоративного сервера 2024 offline-версии.

#### Предварительная подготовка.   

Устанавливаем ОС Астра 1.7.4 образ 1.7.4-24.04.2023_14.23.iso

После установки выполняем команды:

Открываем репозитории `` nano /etc/apt/sources.list``

![image](https://github.com/user-attachments/assets/a9342a3c-bdbd-44fb-8f90-19b6b16f4065)
```bash
apt install open-vm-tools
```
```bash
apt update
apt install astra-update
apt install dnsutils
```
Всё, больше никаких манипуляций с обновлениями.

Проверим версию ``cat /etc/astra/build_version``

Должна быть 1.7.4.7

![image](https://github.com/user-attachments/assets/7050daa1-c528-4897-b120-892af3d87965)

Если версия такая, идём дальше.

Добавим и запустить службу синхронизации времени chrony в автозапуск.
>[!Warning]
>Серверная служба chronyd (пакет chrony) Может обеспечивать работу ОС в режиме как сервера точного времени, так и клиента. Является штатной службой времени для использования с контроллерами домена FreeIPA.

Служба chrony по умолчанию не установлена, установить можно так
```bash
sudo apt install chrony
sudo systemctl start chrony
sudo systemctl enable chrony
```
>[!Warning]
>Так как порт закрыт, если слушает порт udp 123: ``sudo ss -ulpn | grep chronyd`` - тогда не надо.
>Нужно, прописать наш доменный сервер в качестве источника синхронизации времени.  
>Для этого укажем его адрес в ``/etc/systemd/timesyncd.conf`` на остальных серверах. 
```bash
[Time]
NTP=192.168.25.100
А затем перезапустим службу синхронизации времени ``systemctl restart chrony``
```
Делаем статический адрес. Отключаем NetworkManager.

Переписываем свой IP дарес, шлюз, маску, не ошибиться при настройке статического IP-адреса.
```bash
nmcli dev show
```
![image](https://github.com/user-attachments/assets/e4dfa035-87bb-48e1-8a0e-11a11db3717f)

Откючаем и забываем, на серверах не должно быть динамического адреса.
```bash
sudo systemctl status NetworkManager //проверяем статус службы NetworkManager
sudo systemctl stop NetworkManager //останавливает службу
sudo systemctl disable NetworkManager //удаляет её из автозагрузки
sudo systemctl mask NetworkManager //останавливает активность службы
astra-noautonet-control disable //контрольный выстрел
```
![image](https://github.com/user-attachments/assets/27f2a9f5-b55a-44fc-ba41-1345cd231627)

Настраиваем статический адрес службы ``networking.service`` вводим команду: ``nano /etc/network/interfaces``
```bash
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto eth0
allow-hotplug eth0
iface eth0 inet static
address 192.168.25.91
netmask 255.255.255.0
gateway 192.168.25.10
```
![image](https://github.com/user-attachments/assets/00d2ccda-055e-444a-8853-c4aebd40b6dc)

Чтобы применить новые настройки, перезагружаем машину:
```bash
reboot
```
Если всё правильно сделали, то ответ на введённую команду ``sudo systemctl status NetworkManager`` после перезагрузки ответ будет таким, пока не перезагружаем:

![image](https://github.com/user-attachments/assets/25a62ca3-5814-47af-96a0-37f04065a4f2)

После загрузки, проверяем
```bash
ping 77.88.8.8 -c 4
```
![image](https://github.com/user-attachments/assets/f3779d53-5032-45f7-bdab-ffa28a56d2ab)

Если пинга нет, смотрите прописаны ли DNS записи в файле ``nano /etc/resolv.conf``. 

Теперь в файл hosts добавим строки с именем сервера ``nano /etc/hosts``.
```bash
127.0.0.1        localhost.localdomain   localhost
# 127.0.1.1      r7mx1.it.company.lan    r7mx1   --обязательно закомментировать
192.168.25.91    r7mx1.it.company.lan    r7mx1
192.168.25.201   dc01.it.company.lan     dc01 

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
![image](https://github.com/user-attachments/assets/27ed8d1f-1a38-48f6-af36-1c3fe0e211a2)

Настраиваем ``FQDN`` имя первого контроллера домена:
```bash
hostnamectl set-hostname r7mx1.it.company.lan
```
Перезапустим сетевой интерфейс для применения настроек
```bash 
systemctl restart networking.service
```
Проверяем
```bash
hostname -s
hostname -f // если не работает проверяем запись в файле etc/hosts
```
Проверяем resolv.conf
```bash
cat /etc/resolv.conf
search it.company.lan
nameserver 77.88.8.8
nameserver 192.168.25.201 //наш контроллер домена, где настроен DNS
```
![image](https://github.com/user-attachments/assets/4ffaca52-b682-4ac0-bab1-75a39456d7c5)

#### Установка Корпоративного сервера 2024 offline-версии. 

Скачиваем с их сайта архив **Оффлайн установка** CDinstall_2.0.2024.14752_Astra_1.7.4_offline.zip<br>

> https://r7-office.ru/downloadserver#retail

или с нашей шары и закидываем в корень папки ``/mnt`` переходим в неё и распаковываем
```bash
cd /mnt/
unzip CDinstall_2.0.2024.14752_Astra_1.7.4_offline.zip
```
![image](https://github.com/user-attachments/assets/29d3d29e-d27f-4732-8851-918518dc749f)

После распаковки заходим в папку
```bash
cd /mnt/CDDiskPack/CDinstall_Astra_1.7.4/sslcert
проваливаемся то этому пути
/mnt/CDDiskPack/CDinstall_Astra_1.7.4/sslcert#
```
##### Генерируем самоподписанные сертификаты.
Генерация самоподписанных SSL-сертификатов включает в себя четыре простых шага:

- Шаг 1: Создайте конфигурационный файл (например с названием, openssl.cnf) с поддержкой wildcard:
```bash 
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C = RU
ST = Moscow
L = Moscow
O = Rosreestr
CN = *.it.company.lan 

[v3_req]
keyUsage = keyEncipherment, dataEncipherment, digitalSignature
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.it.company.lan  
DNS.2 = it.company.lan  
```
- Шаг 2:  Команда создаст 2048-битный закрытый ключ **it.company.lan.key**
  
  в этой папке /mnt/CDDiskPack/CDinstall_Astra_1.7.4/sslcert#
```bash
openssl genrsa -out it.company.lan.key 2048
```

- Шаг 3: Следующая команда создаст сертификат CSR-Certificate Signing Request **it.company.lan.csr** для существующего ключа (it.company.lan.key):
```bash
openssl req -new -key it.company.lan.key -out it.company.lan.csr -config openssl.cnf
```

- Шаг 4: Следующая команда сгенерирует самоподписанный сертификатс **it.company.lan.crt** на основе существующего сертификата (it.company.lan.csr) и закрытого ключа (it.company.lan.key):
```bash
openssl x509 -req -days 365 -in it.company.lan.csr -signkey it.company.lan.key -out it.company.lan.crt -extensions v3_req -extfile openssl.cnf
```

##### Добавляем корневой сертификат в доверенные сертификаты.

Скопируйте файл вашего сертификата (it.company.lan.crt) в хранилище сертификатов в каталог usr/local/share/ca-certificates/:
```bash
мы сейчас долны находиться в той папке где мы создали сертификаты  /mnt/CDDiskPack/CDinstall_Astra_1.7.4/sslcert#
sudo cp it.company.lan.crt /usr/local/share/ca-certificates/
```
Обновите хранилище сертификатов командой:
```bash
update-ca-certificates -v
```
![image](https://github.com/user-attachments/assets/733724e8-53fa-4f38-be70-879a6c4a7ce7)

Если сертификаты успешно добавлены, появится сообщение о том, что сертфикат скопирован в /etc/ssl/certs/:
```bash
Updating certificates in /etc/ssl/certs…
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d
```
##### Проверяем работу сертификатов.

**CSR**

Эта команда проверит CSR и отобразит данные, указанные в запросе:
```bash
openssl req -text -noout -verify -in it.company.lan.csr
```
![image](https://github.com/user-attachments/assets/e76907d3-0359-46a3-8070-de203b449168)

**Ключ**

Следующая команда проверит ключ и его действительность:
```bash
openssl rsa -in it.company.lan.key -check
```
![image](https://github.com/user-attachments/assets/5072b407-68e4-4a16-b087-f459c944d069)

**SSL сертификат**

Когда вам нужно проверить сертификат, дату его истечения и кто его подписал, используйте следующую команду OpenSSL:
```bash
openssl x509 -in it.company.lan.crt -text 
```
![image](https://github.com/user-attachments/assets/bb0f84f5-0fcc-4b33-8828-00b9e474226f)

Обновите хранилище:
```bash
update-ca-certificates --fresh
```
Теперь Вы можете убедиться, что ваша ОС доверяет сертификату с помощью команду:
```bash
#openssl verify it.company.lan.crt
```
![image](https://github.com/user-attachments/assets/9d33ea5b-6500-42c0-9f81-555bf97aadd1)

#### Далее переходим к скрипту запуска установки КС.
```bash
из папки в которой создали сертификаты /mnt/CDDiskPack/CDinstall_Astra_1.7.4/sslcert/#
переходим 
cd ..
проваливаемся
/mnt/CDDiskPack/CDinstall_Astra_1.7.4/#
смотрим что в папке скрипт присутствует  ls -l
даём права на выполнение его
chmod +x offline_installer.sh
запускаем
./offline_installer.sh
```
![image](https://github.com/user-attachments/assets/caa684ee-d0b8-4618-bad7-ab36eda8d02b)

![image](https://github.com/user-attachments/assets/986d1e7b-d33f-4234-8fd7-aed5e9451eda)

![image](https://github.com/user-attachments/assets/9637b5a5-3114-486a-9dba-18c67441ba18)

![image](https://github.com/user-attachments/assets/878632c3-5ad9-445a-a670-3599e0723062)

![image](https://github.com/user-attachments/assets/42f7d7f0-3b6a-494b-a527-a15b7246c2b6)

![image](https://github.com/user-attachments/assets/2237c1d7-2c86-4491-ae5f-bea349f658cd)

![image](https://github.com/user-attachments/assets/7cce156d-c595-45fe-b81f-47d202d8555b)

![image](https://github.com/user-attachments/assets/0135cee8-32f3-446d-91df-b1ca94db8e9a)

![image](https://github.com/user-attachments/assets/3f5778a3-0834-4aa3-a11d-a182a9bb3aa8)

![image](https://github.com/user-attachments/assets/83f23eaf-2540-4dca-a145-1d2c7066b182)

![image](https://github.com/user-attachments/assets/84e27862-4db4-4d62-a272-eaa53aa900d3)

![image](https://github.com/user-attachments/assets/b8b03d01-4e58-46ef-ac1d-cb19e0719d60)

![image](https://github.com/user-attachments/assets/10eff70d-b8db-421e-ad40-69772b77fa5d)

![image](https://github.com/user-attachments/assets/5afb9ace-7c43-48b1-83ce-22cd7e17e2ed)

![image](https://github.com/user-attachments/assets/2f2e3341-85de-458d-8aac-40ca5e562733)

![image](https://github.com/user-attachments/assets/79e5b956-5dbf-4db6-8240-77bacc7ed8df)

>[!Warning]
>Если Вы выбрали установки без HTTPS, то, после инсталляции, почтовый сервер работать не будет. Он не запустится.

![image](https://github.com/user-attachments/assets/ae23bfe7-4777-4147-ae3a-4776c64e94a2)

![image](https://github.com/user-attachments/assets/6aba3925-df9e-4c4b-ba06-c5dd15954b0d)

![image](https://github.com/user-attachments/assets/64ec3ab8-8845-4765-bdf5-59e5af56220d)

![image](https://github.com/user-attachments/assets/b7bfadab-6d3f-4f86-aa85-b9e1306ff9cf)

![image](https://github.com/user-attachments/assets/8135dcfa-eaae-46f7-bb11-27517b0ea0a3)

![image](https://github.com/user-attachments/assets/02f3207b-6504-493e-a376-f533b36afa0f)

![image](https://github.com/user-attachments/assets/8a648089-4a26-41d2-ba66-47a275ab64cc)

![image](https://github.com/user-attachments/assets/a3bc029d-20b3-4918-860b-77c4556ccbef)

#### Установка почтового сервера R7.

>[!Warning]
>Рекомендуем, перед продолжением инсталляции, прописать записи в DNS, для работы почтового сервера.

Необходимо добавить запись А (ваш почтовый сервер hostname -f) и обратную запись, а также запись MX и TXT v=spf1 +mx ~all

Пример:

|        |it.company.lan       	|TTL          	|Приоритет
|--------|-----------------------|---------------|--------------|
|MX	 |r7mx1.it.company.lan  |300            |10		|
|TXT     |it.company.lan         |TTL            |		|
|	 |v=spf1+mx~all          |300            |		|
|A       |r7mx1.it.company.lan  |TTL            |		|
|	 |192.168.18.141          |300            |		|
   
Теперь по подробней.

**MX-запись** — это тип DNS-записи, который указывает, какой сервер отвечает за прием электронной почты для домена.<br> 
MX-запись указывает на доменное имя почтового сервера (например, в нашем случае - r7mx1.it.company.lan), которое должно иметь A-запись (IPv4), чтобы связать домен с IP-адресом. Чем меньше число, тем выше приоритет.

>MX-записи не могут указывать напрямую на IP-адрес, только на доменное имя.

Проверить MX-записи можно через команды в терминале:
```bash
nslookup -type=mx it.company.lan
или так
dig mx it.company.lan 
```
Запись ``v=spf1 +mx ~all`` в DNS — это SPF-запись, которая помогает защитить домен от подделки электронной почты (спуфинга). <br>Она указывает, какие серверы имеют право отправлять письма от имени вашего домена.<br>
SPF-запись v=spf1 +mx ~all разрешит отправку писем только с r7mx1.it.company.lan, а письма с других серверов будут отклонены или помечены.

Идём далее - Установка почтового сервера - ДА

В данном окне надо внести имя вашего MX почтового сервера, который прописан в записи А на контроллере домена. 

В моём случае запись А в DNS такая ``A  r7mx1.it.company.lan  TTL``

![image](https://github.com/user-attachments/assets/f4e3c2b9-0d31-4861-8753-33b1551bb8c9)

![image](https://github.com/user-attachments/assets/afb16678-0b41-4330-94e4-83f0c0f61b1b)

![43](https://github.com/user-attachments/assets/396395fb-010e-4b6d-8c33-a9d1c7243f25)

![44](https://github.com/user-attachments/assets/e0cb49e9-6577-422a-b485-954d502aea6e)

![45](https://github.com/user-attachments/assets/6c0ebd51-4130-436e-92f9-d9af2ddc4be9)

**DKIM** — это технология аутентификации электронной почты, которая позволяет проверить, что письмо действительно отправлено от имени домена и не было изменено в процессе доставки. DKIM использует цифровую подпись, чтобы подтвердить подлинность отправителя и целостность содержимого письма.<br>
DKIM-запись хранится в DNS домена в формате TXT-записи и выглядит примерно так:
```bash
selector._domainkey.it.company.lan.  TXT  "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC..."
```
После инсталляции в консоли будет предложено сделать TXT запись.

##### Далее доустановим модуль Графика.

Для Astra Linux 1.7.4 Orel, Astra Linux 2.12
1. Добавляем ключ
```bash
sudo curl -s https://download.r7-office.ru/repos/RPM-GPG-KEY-R7-OFFICE.public | sudo gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/r7.gpg --import && sudo chmod 644 /etc/apt/trusted.gpg.d/r7.gpg
```
2. Добавляем репозиторий
```bash
sudo echo "deb https://downloads.r7-office.ru/repository/r7-desktop-astra/ astralinux main" | sudo tee /etc/apt/sources.list.d/r7.list
```
3. Добавляем файл для авторизации в репозитории
```bash
nano /etc/apt/auth.conf.d/r7.conf
```
Если данной директории нет
```bash
/etc/apt/auth.conf.d
Необходимо добавить данный файл:
touch /etc/apt/auth.conf
```
3.1. Добавить данные
```bash
machine downloads.r7-office.ru
login desktop
password gyxiLab84FByn7sCTd5JY
```
3.2. Изменить доступ на файл
```bash
sudo chmod 600 /etc/apt/auth.conf.d/r7.conf
```
Если директории /etc/apt/auth.conf.d нет, то выполнит эту команду:
```bash
sudo chmod 600 /etc/apt/auth.conf
```
4. Обновляем информацию о пакетах
```bash
sudo apt update
```
5. Устанавливаем приложения
```bash
apt install r7grafika
```
Теперь в файл hosts добавим строку ``127.0.0.1  draw.it.company.lan``.
```bash
127.0.0.1        localhost.localdomain   localhost
# 127.0.1.1      r7mx1.it.company.lan    r7mx1   --обязательно закомментировать
192.168.25.91    r7mx1.it.company.lan    r7mx1
192.168.25.201   dc01.it.company.lan     dc01 

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

127.0.0.1 it.company.lan
127.0.0.1 admin.it.company.lan
127.0.0.1 contacts.it.company.lan
127.0.0.1 projects.it.company.lan
127.0.0.1 cdisk.it.company.lan
127.0.0.1 ds.it.company.lan
127.0.0.1 cmail.it.company.lan
127.0.0.1 calendar.it.company.lan
127.0.0.1  draw.it.company.lan
```
![image](https://github.com/user-attachments/assets/0265616f-9962-4b69-be48-b28842ca36c8)

В итоге должно получиться так

![image](https://github.com/user-attachments/assets/a9bfba9a-fe3a-4a95-b021-fd410003e48e)

