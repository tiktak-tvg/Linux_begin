#### Установка контролера домена ALD PRO  на Астра Линукс 1.7.6 будет состоять из двух этапов.

- Предварительная подготовка сервера.
- Установка ALD Pro.

##### Предварительная подготовка сервера.

Что надо знать?
1. Рекомендуемые версии такие с 1.7.4-24.04.2023_14.23 до 1.7.6.15-15.11.24_17.20 Смоленск<br>
2. ALD Pro не поддерживает ядра hardened. Поддерживаются только generic ядра.<br>
3. Минимальное количество мегабайт оперативной памяти **4Гб**, необходимое для развертывания служб контроллера домена ALD Pro. Развертывание контроллера на узле запускается только в том случае, когда на нем установлено количество оперативной памяти большее или равное указанному. Значение по умолчанию – 4096 (4Гб).
4. Для установки ALD PRO необходимо использовать редакцию Astra Linux с максимальным уровнем защищенности – **Смоленск** или усиленным уровнем защищенности – **Воронеж**.<br>**Орел** – вариант лицензирования несертифицированной ОС с базовым уровнем защищенности, не может применяться в системах, где предъявляются требования в части защиты информации.<br>
   > Переключает и отображает уровни защищенности ОС:<br>
   
       0  Базовый;
       1  Усиленный;
       2  Максимальный.
5. Для установки ALD PRO настоятельно рекомендуется использовать статическую адресацию на серверах.<br>
6. Для имени домена рекомендуется выбирать такое имя, которые не будет конфликтовать с другими вашими сервисами.
      - Например, для LAD Pro выделить отдельный домен подуровня(третьего уровня). Например, it.company.lan.


Проверяем на рекомендуемое соответствие
```bash
cat /etc/astra/build_version
sudo astra-modeswitch getname
sudo astra-modeswitch list
```
![image](https://github.com/user-attachments/assets/8e2a245b-c851-48d5-a810-c15978a2dcf2)

Если при установке выбрали режим другой, то переходим на требуемый (выбирайте при установке сразу нужный, чтобы было меньше лишних манипуляций)
```bash
sudo astra-modeswitch set 2
```
>[!Warning]
>При изменении уровня защищенности:
- В сторону снижения уровня защищенности: автоматически отключаются опции, которые для данного уровня защищенности недоступны;
- В сторону увеличения уровня защищенности: при увеличении уровня защищенности состояние опций (МРД и МКЦ) автоматически не изменяется, но опции, доступные в новом режиме, становятся доступными для включения.

Из того, что "состояние опций автоматически не изменяется"  следует, что после выполнения команды повышения уровня, например: 
```bash
sudo astra-modeswitch set 2
нужно будет отдельно включить необходимые опции. Полный набор команд для включения всех опций:
sudo astra-mic-control enable
sudo astra-mac-control enable
sudo astra-digsig-control enable
sudo astra-secdel-control enable
sudo astra-swapwiper-control enable
```
Добавим и запустить службу синхронизации времени chrony в автозапуск.
>[!Warning]
>Серверная служба chronyd (пакет chrony) Может обеспечивать работу ОС в режиме как сервера точного времени, так и клиента. Является штатной службой времени для использования с контроллерами домена FreeIPA.

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
>[!Warning]
>Серверная служба chronyd (пакет chrony) Может обеспечивать работу ОС в режиме как сервера точного времени, так и клиента. Является штатной службой времени для использования с контроллерами домена FreeIPA.<br>
>Если при начальной настройке будущего контроллера домена желаете использовать службу синхронизации времени ntp, то делается это следующим образом (но!!! после установки контроллера домана, будет всё равно использоваться служба chrony).

Добавим и запустить службу синхронизации времени ntp в автозапуск:
```bash
sudo systemctl status ntp
sudo systemctl start ntp
sudo systemctl enable ntp
```
Проверить работоспособность службы NTP в консоли с помощью команды: ``ntpq -p``

Настроить на локальный сервер можно здесь ``nano /etc/ntp.conf``
Добавить в соответствующей секции следующие строки:
```bash
server 127.127.1.0
fudge 127.127.1.0 stratum 10
restrict <network> mask <netmask> nomodify notrap

sudo systemctl enable ntp
sudo systemctl restart ntp
ntpq -p
remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
 LOCAL(0)        .LOCL.          10 l    7   64    1    0.000   +0.000   0.000
```
#### Настраиваем сеть и установливаем статический IP адрес.
Узнаем название сетевого интерфейса, IP адресс, шлюз
```bash
ip a | grep inet 
route 
```
![image](https://github.com/user-attachments/assets/bb002450-e8a9-4fc5-8025-3973534e0813)

или так
```bash
nmcli dev sh
```

Для начала сделаем статический адрес на будущем контроллере домена.

>[!Warning]
>На рабочих станциях этого делать не обязательно, да и не нужно.

```bash
sudo systemctl status NetworkManager //проверяем статус службы NetworkManager
sudo systemctl stop NetworkManager //останавливает службу
sudo systemctl disable NetworkManager //удаляет её из автозагрузки
sudo systemctl mask NetworkManager //останавливает активность службы
```
отключает автоматическую настройку сетевых подключений, блокируя работу служб NetworkManager, network-manager и connman, а также отключает элемент управления сетью в трее графического интерфейса.
```bash
astra-noautonet-control <enable/disable/status/is-enabled>
astra-noautonet-control is-enabled
ВКЛЮЧЕНО 
astra-noautonet-control disable 
astra-noautonet-control is-enabled
ВЫКЛЮЧЕНО
astra-noautonet-control status
НЕАКТИВНО
```
Если всё правильно сделали, то ответ на введённую команду ``sudo systemctl status NetworkManager`` будет таким:

![image](https://github.com/user-attachments/assets/25a62ca3-5814-47af-96a0-37f04065a4f2)

и сеть в трее графического интерфейса будет не активна.

![image](https://github.com/user-attachments/assets/d7ecd977-c8da-4deb-bee6-3f5a0e3046ec)

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
address 192.168.25.115
netmask 255.255.255.0
gateway 192.168.25.10
```
![image](https://github.com/user-attachments/assets/4389923f-e7d5-4443-a7a5-ab44d957bdc7)

- auto eth0  --поднимать интерфейс автоматически при старте системы
- allow-hotplug eth0 --автоматически выполнять перезапуск интерфейса при его падении
- iface eth0 inet static --к какому интерфейсу мы привязываем статический адрес
- address 192.168.25.115 --статический адрес
- netmask 255.255.255.0  --маска
- gateway 192.168.25.10  --шлюз

Проверим верны ли настройки и перезапустим сервер для применения всех изменений настроек
```bash
systemctl restart networking.service // если ошибки не выдало делаем ребут

reboot
```
> [!Warning]
> Предложенные зоны ``.lan`` и ``.internal`` не зарегистрированы в глобальном списке ``Top-Level Domains``, но всегда будет оставаться вероятность, что их ведут в эксплуатацию в будущем.

> Соответственно, следует использовать зоны ``.lan``, ``.internal`` и ``.local`` учитывая эти риски.

Теперь после перезагрузки в файл hosts добавим строки с именем сервера ``nano /etc/hosts``.
```bash
127.0.0.1        localhost.localdomain localhost
# 127.0.1.1      dc01.it.company.lan dc01   --обязательно закомментировать
192.168.25.115   dc01.it.company.lan dc01

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

![image](https://github.com/user-attachments/assets/74308d59-9e2d-45f6-94a4-9e4bb0b1dd6b)

Настраиваем ``FQDN`` имя первого контроллера домена:
```bash
hostnamectl set-hostname dc01.it.company.lan
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
![image](https://github.com/user-attachments/assets/acf5aa2f-4a59-4ab8-9189-a919562c34d5)

Перезапустим виртуальную машину для проверки применения настроек
```bash 
reboot
```
Вводим команду ``nano /etc/resolv.conf`` и смотрим какие данные показывает, если всё настроили правильно должно быть так
```bash
search it.company.lan
nameserver 192.168.25.10
```
Вводим команду ``nano /etc/resolv.conf`` и прописываем DNS, чтобы пока у нас работали репозитории
```bash
search it.company.lan
#nameserver 192.168.25.10
nameserver 77.88.8.8
```
Перезапустим сетевой интерфейс для применения настроек
```bash 
systemctl restart networking.service
```
После перезагрузки вводим команду ``ifquery`` результат должен быть такой

![image](https://github.com/user-attachments/assets/bb582400-4d85-4e35-80b5-c318fbd18ddd)

Проверяем пинг ``ping -c 4 dl.astralinux.ru``
Проверяем
```bash
hostname -s
hostname -f 
```
Если всё верно идём дальше.

Для проверки работы DNS установим пакет утилит ``nslookup, dig`` командой ``apt instal dnsutils``

Добавляем репозитории.
>[!Warning]
>Репозиторий base включает репозитории main и update, а репозиторий extended содержит большое количество дополнительного программного обеспечения.

Вводим команду ``nano /etc/apt/sources.list``
```bash
# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC Основной репозиторий
#deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free
# Оперативные обновления основного репозитория
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free
# Рекомендуемые репозитории для установки сервера
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/repository-base/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/repository-extended/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/repository-update/ 1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.6/uu/2/repository-update/ 1.7_x86-64 main contrib non-free
```
![image](https://github.com/user-attachments/assets/39175691-3745-4c96-bad4-943093fdd053)

Определения репозиториев также могут быть указаны файлах, расположенных в каталоге /etc/apt/sources.list.d/. Файлы могут иметь произвольное имя c обязательным расширением ".list".
Для ALD PRO в папкe source.list.d добавим файл с записью
```bash
cat > /etc/apt/sources.list.d/aldpro.list
deb https://dl.astralinux.ru/aldpro/frozen/01/2.5.0 1.7_x86-64 main base
```
Для использования сетевых репозиториев, работающих по протоколу HTTPS необходимо, чтобы в системе был установлен пакет ``apt-transport-https`` и пакет ``ca-certificates``.<br> 
Проверить наличие пакетов можно командой: ``apt policy apt-transport-https ca-certificates``

![image](https://github.com/user-attachments/assets/c23e2076-dcc7-4ba0-a749-c4619add9c02)

>[!Warning]
>Установить пакеты, если вдруг утеряны ``apt-transport-https`` и ``ca-certificates`` можно командой: ``sudo apt install apt-transport-https ca-certificates``

Обновляем
```bash
apt update
 apt list --upgradable
 apt dist-upgrade -y -o Dpkg::Optoins::=--force-confnew
```
![image](https://github.com/user-attachments/assets/6b6178cd-08fc-49d7-a737-56012eac8528)

Перезагружаем сервер ``reboot``

##### Установка первого контроллера ALD Pro

После предварительной настройки продолжаем установку.
Установка ALD Pro
1. Устанавливаем необходимые пакеты:
```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q aldpro-mp aldpro-gc aldpro-syncer
```
- aldpro_enable_syncer – установка модуля синхронизации ``aldpro-syncer``. Этот модуль необходим для использования расширенных функций интеграции с доменом Microsoft Active Directory.
- aldpro_enable_gc – установка модуля глобального каталога ``aldpro-gc``. Этот модуль необходим, если используется топология из контроллера домена и нескольких реплик. Службы, предоставляемые этим модулем, выполняют синхронизацию данных пользователей между контроллером домена и его репликами.

2. Теперь повысим сервер до контроллера домена. Дополнительно отключим историю выполнения команд, чтобы пароль не был записан в эту историю:
```bash
set + o history
sudo aldpro-server-install -d it.company.lan -n dc01 -p 'QwertyQAZWSX' --ip 192.168.25.115 --no-reboot --setup_syncer --setup_gc
```
3. После завершения установки проверим журнал на наличие ошибок:
```bash
sudo grep error: /var/log/apt/term.log
```
4. Дожидаемся окончания процедуры повышения сервера до контроллера домена и проверяем:   
```bash
sudo aldproctl status
sudo ipactl status
```
![14](https://github.com/user-attachments/assets/00cc5caa-639d-4927-a205-cf1cd7ea3183)

5. Включаем обратно историю ведения команд:
```bash
set -o history
```
6. Проверим настройки разрешения имен:
```bash
sudo cat /etc/resolv.conf
```
![13](https://github.com/user-attachments/assets/bf4573f7-2c62-4db3-a66c-6fd0ba009e9b)

В файле должен быть указан ваш домен и адрес сервера – 127.0.0.1, т.к. этот файл настраивается на службу bind9.

7. Перезагружаем сервер.

Входим в домен

![51](https://github.com/user-attachments/assets/1a04154c-2e42-4ece-8241-09851541684f)
![52](https://github.com/user-attachments/assets/5eebdbbe-5339-4b38-a058-829882b16448)
![53](https://github.com/user-attachments/assets/54026fd5-b72d-4311-bc52-f80e4f6ce050)

##### Отключение DNSSEC
```bash
sudo sed -i 's/dnssec-validation yes/dnssec-validation no/g' /etc/bind/ipa-options-ext.conf
sudo systemctl restart bind9-pkcs11.service

sudo cat > /etc/bind/ipa-options-ext.conf
allow-recursion { any; };
allow-query-cache { any; };
```
Настройка глобального перенаправления DNS

Роли и службы сайта → Служба разрешения имён → Глобальная конфигурация DNS
Указать IP-адрес внешнего резолвера
![image](https://github.com/user-attachments/assets/d6f86c4b-62fe-4df8-a5e7-c2c62aef3beb)

Например: 77.88.8.8 или 8.8.8.8 или 1.1.1.1

![image](https://github.com/user-attachments/assets/0f05b948-9552-45ca-ad05-31553afdff1e)

Если всё правильно сделали, то при проверке настроек должно быть так
```bash
klist
```

![image](https://github.com/user-attachments/assets/18290db8-8697-492f-9a48-0a41361318f4)

Если вдруг там нет билета HTTP добляем его вручную и заодно проверим права пользователя admin 
```bash
ipa user-show admin
```

![image](https://github.com/user-attachments/assets/2e1e5461-e93b-4660-89ae-f0204d32a3d0)

![image](https://github.com/user-attachments/assets/6e0a5657-b62e-451e-846b-5d6468aed357)

![image](https://github.com/user-attachments/assets/6323c873-2a95-405e-9cfa-1d6ac3ae94c4)

Проверяем работу DNS
```bash
root@dc01:~# systemctl status bind9
● bind9.service
   Loaded: masked (Reason: Unit bind9.service is masked.) //служба должа быть отключена по маске
   Active: inactive (dead)
root@dc01:~#

systemctl status bind9-pkcs11.service
```
![image](https://github.com/user-attachments/assets/de9490ec-dda9-4044-b1e5-da45befda99b)

```bash
ipa dnsconfig-show
```
![image](https://github.com/user-attachments/assets/e6ddbcc5-6ca1-4701-8707-6be13929c2aa)

Далее, если всё норм подключаем ещё один контроллер домена.

Проверяем, что мы его видим

![64](https://github.com/user-attachments/assets/b1b3f1a2-5f3d-4b2c-8f9e-b279e06c4aff)

На другом контроллере домена наш первый контроллер домена должен пинговаться, проверяем (по короткому и длинному имени)

![image](https://github.com/user-attachments/assets/e61bd337-e67f-4cbf-b9f4-7b29f3f36de0)

Если всё ок, вводим в домен
```bash
/opt/rbta/aldpro/client/bin/aldpro-client-installer --domain it.company.lan --account admin --password 'ваш пароль' --host dc03 --gui --force
```

Далее после перезагрузки входим в домен


