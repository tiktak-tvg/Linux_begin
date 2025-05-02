#### Установка контролера домена ALD PRO будет состоять из двух этапов.

- Предварительная подготовка сервера.
- Установка ALD Pro.

##### Предварительная подготовка сервера.

Что надо знать?
1. Рекомендуемые версии такие с 1.7.4-24.04.2023_14.23 до 1.7.6.15-15.11.24_17.20 Смоленск<br>
2. ALD Pro не поддерживает ядра hardened. Поддерживаются только generic ядра.<br>
3. Минимальное количество мегабайт оперативной памяти, необходимое для развертывания служб контроллера домена ALD Pro. Развертывание контроллера на узле запускается только в том случае, когда на нем установлено количество оперативной памяти большее или равное указанному. Значение по умолчанию – 4096 (4 ГБ).
4. Необходимо использовать редакцию Astra Linux с максимальным уровнем защищенности – Смоленск или усиленным уровнем защищенности – Воронеж.<br>**Орел** – вариант лицензирования несертифицированной ОС с базовым уровнем защищенности, не может применяться в системах, где предъявляются требования в части защиты информации.<br>
   > Переключает и отображает уровни защищенности ОС:<br>
   
       0  Базовый;
       1  Усиленный;
       2  Максимальный.
5. Настоятельно рекомендуется использовать статическую адресацию на серверах.<br>
6. Для имени домена рекомендуется выбирать такое имя, которые не будет конфликтовать с другими вашими сервисами.
      - Например, для LAD Pro выделить отдельный домен подуровня(третьего уровня). Например, it.company.lan.

Проверяем на рекомендуемое соответствие
```bash
cat /etc/astra/build_version
sudo astra-modeswitch getname
sudo astra-modeswitch list
```
![image](https://github.com/user-attachments/assets/8e2a245b-c851-48d5-a810-c15978a2dcf2)

Если режим другой, то выбирайте нужный
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
Добавим и запустить службу синхронизации времени ntp в автозапуск:
```bash
sudo systemctl status ntp
sudo systemctl start ntp
sudo systemctl enable ntp
```bash
Настраиваем сеть и установливаем статический IP адрес.
узнаём название сетевого интерфейса, IP адресс, шлюз
```bash
ip a | grep inet 
route 
```
![image](https://github.com/user-attachments/assets/bb002450-e8a9-4fc5-8025-3973534e0813)

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

Настраиваем статический адрес вводим команду: ``nano /etc/network/interfaces``
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
address 192.168.25.112
netmask 255.255.255.0
gateway 192.168.25.10
```
![image](https://github.com/user-attachments/assets/4389923f-e7d5-4443-a7a5-ab44d957bdc7)

- auto eth0  --поднимать интерфейс автоматически при старте системы
- allow-hotplug eth0 --автоматически выполнять перезапуск интерфейса при его падении
- iface eth0 inet static --к какому интерфейсу мы привязываем статический адрес
- address 192.168.25.112 --статический адрес
- netmask 255.255.255.0  --маска
- gateway 192.168.25.10  --шлюз

Вводим команду ``nano /etc/resolv.conf`` и прописываем DNS, чтобы пока у нас работали репозитории
```bash
nameserver 77.88.8.8
```
> [!Warning]
> Предложенные зоны ``.lan`` и ``.internal`` не зарегистрированы в глобальном списке ``Top-Level Domains``, но всегда будет оставаться вероятность, что их ведут в эксплуатацию в будущем.
> Соответственно, следует использовать зоны ``.lan``, ``.internal`` и ``.local`` учитывая эти риски.

Также в файл hosts добавим строки с именем сервера ``nano /etc/hosts``.
```bash
127.0.0.1       localhost
#127.0.1.1      dc01.it.company.lan dc01   --обязательно закоментировать
192.168.25.115  dc01.it.company.lan dc01

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
Проверяем
```bash
hostname -s
hostname -f
hostname -I
```
![image](https://github.com/user-attachments/assets/acf5aa2f-4a59-4ab8-9189-a919562c34d5)

Перезапустим сетевой интерфейс для применения настроек
```bash 
systemctl restart networking.service
```
После перезагрузки вводим команду ``ifquery`` результат должен быть такой
![image](https://github.com/user-attachments/assets/bb582400-4d85-4e35-80b5-c318fbd18ddd)

Добавляем репозитории
```bash
cat /etc/apt/sources.list
nano /etc/apt/sources.list
# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC
# Основной репозиторий
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/     1.7_x86-64 main contrib non-free
# Оперативные обновления основного репозитория
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/   1.7_x86-64 main contrib non-free

deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-base/          1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-extended/      1.7_x86-64 main contrib non-free
#или
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-base/     1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-extended/ 1.7_x86-64 main contrib non-free
```
Для использования сетевых репозиториев, работающих по протоколу HTTPS необходимо, чтобы в системе был установлен пакет apt-transport-https и пакет ca-certificates. Проверить наличие пакетов можно командой:
```bash
apt policy apt-transport-https ca-certificates
```
![image](https://github.com/user-attachments/assets/273040a4-1d40-45b8-9368-5f311f69b6ba)

Установить пакеты apt-transport-https и ca-certificates можно командой:
```bash
sudo apt install apt-transport-https ca-certificates
```
Обновим
```bash
apt update
apt dist-upgrade
```
Можно добавить репозитории от astra
```bash
astra-update -a -r
```
![image](https://github.com/user-attachments/assets/5aa5e8a7-80a6-4fc4-b789-882388b22a08)

Перезагружаем сервер
```bash
reboot
```

Определения репозиториев также могут быть указаны файлах, расположенных в каталоге /etc/apt/sources.list.d/. Файлы могут иметь произвольное имя c обязательным расширением ".list".
Для ALD PRO в папкe source.list.d добавим файл с записью
```bash
cat > /etc/apt/sources.list.d/aldpro.list
#deb https://dl.astralinux.ru/aldpro/frozen/01/2.3.0 1.7_x86-64 main base
deb https://dl.astralinux.ru/aldpro/frozen/01/2.5.0 1.7_x86-64 main base
```
Далее обновляем
```bash
apt update
 apt list --upgradable
 apt dist-upgrade -y -o Dpkg::Optoins::=--force-confnew
reboot
```

##### Установка первого контроллера ALD Pro

После предварительной настройки продолжаем установку.
Установка ALD Pro
1. Устанавливаем необходимые пакеты:
```bash
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q aldpro-mp aldpro-gc aldpro-syncer
```
2. После завершения установки проверим журнал на наличие ошибок:
```bash
sudo grep error: /var/log/apt/term.log
```
3. Теперь повысим сервер до контроллера домена. Дополнительно отключим историю выполнения команд, чтобы пароль не был записан в эту историю:
```bash
set + o history
sudo aldpro-server-install -d ald.it.lan -n dc1 -p 'gogo23Caru' --ip 192.168.25.112 --no-reboot --setup_syncer --setup_gc
```
4. Дожидаемся окончания процедуры повышения сервера до контроллера домена.
5. Включаем обратно историю ведения команд:
```bash
set -o history
```
6. Проверим настройки разрешения имен:
```bash
sudo cat /etc/resolv.conf
```
В файле должен быть указан ваш домен и адрес сервера – 127.0.0.1, т.к. этот файл настраивается на службу bind9.

7. Перезагружаем сервер.

Входим в домен

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
Добавить права для УЗ admin
```bash
kinit
ipa group-add-member 'ald trust admin' --user admin
```
