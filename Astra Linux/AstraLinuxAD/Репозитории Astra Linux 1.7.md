#### Немного о репозиториях.
```bash
Astra Linux 1.7 по умолчанию настроена на использование локальных репозиториев, и поэтому если предполагается ее использовать в общих целях то необходимо подкорректировать используемые репозитории.
Правим список основных репозиториев:
sudo nano /etc/apt/sources.list
# Заблокировать cd и разблокировать остальные, а так же дописать:
# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC

#deb cdrom:[OS Astra Linux 1.7.1 1.7_x86-64 DVD ]/ 1.7_x86-64 contrib main non-free
# Основной репозиторий
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free

# Оперативные обновления основного репозитория
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free

# Базовый репозиторий
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free

# Расширенный репозиторий
deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free

# Расширенный репозиторий (компонент astra-ce) - используется при необходимости в установке дополнительного ПО, которое не прошло сертификацию!
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 astra-ce

 Обновляем список пакетов:
sudo apt update

 Проверяем наличие в системе пакетов для работы с репозиториями:
sudo apt install -y apt-transport-https ca-certificates

 Далее стандартно обновляем систему:
sudo apt full-upgrade

 И для контроля можно дополнить так (последует перезагрузка!):
sudo astra-update -r -A && sudo reboot

Примечание - я обратил внимание на ляп в виде "потерянного" пакета plymouth. Если увидите сообщение в духе что рекомендуется установить этот пакет, а скорей всего так и будет, то:
sudo apt install -y plymouth-themes
Еще одно дополнение - если при прописывании прочих репозиториев (Debian и прочие внешние репозитории) появятся сообщения про отсутствующие ключи вида 112695A0E562B32A, 54404762BBB6E853 и т.п., то необходимо зарегистрировать их:
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 112695A0E562B32A 54404762BBB6E853 DCC9EFBF77E11517 0E98404D386FA1D9 648ACFD622F3D138
Выше мы использовали официальные репозитории Astra Linux. Теперь подключим все еще официальные репозиторий от разработчиков Лаборатория 50 - https://lab50.net/ :
sudo nano /etc/apt/sources.list.d/lab50.list
deb http://packages.lab50.net/alse/ alse17 main

sudo nano /etc/apt/sources.list.d/security.list
deb http://packages.lab50.net/alse/ alse17-security main contrib non-free

 Убеждаемся что wget установлен в системе:
sudo apt install -y wget

 Ключ для lab50 устанавливаем напрямую:
wget -qO - http://packages.lab50.net/lab50.asc | sudo apt-key add -
sudo apt update
sudo apt install -y lab50-archive-keyring
sudo apt full-upgrade
Если есть необходимость в использовании пакетов которых нет в Astra Linux, или же если требуются свежие версии пакетов, то тогда подключаем репозитории от сообщества Debian:

Внимание! Не забываем что последующие репозитории уже ни в коей мере не гарантируют чистоту своего кода, так как это свободное ПО написанное в том числе обычными людьми со всего мира, среди которых увы но встречаются лица у которых только одна цель - навредить другим!

*Примечание - Для облегчения себе жизни устанавливаем пакеты:
sudo apt install -y debian-archive-keyring dirmngr

Подключаем основной для Астра SE 1.7.3 репозиторий Debian Bullseye (он же Debian 11):

sudo nano /etc/apt/sources.list.d/bullseye.list
deb http://deb.debian.org/debian bullseye main contrib non-free
deb-src http://deb.debian.org/debian bullseye main contrib non-free

deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free
deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free

deb http://deb.debian.org/debian bullseye-updates main contrib non-free
deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free

И на изюминку добавляем Bullseye-Backports:
sudo nano /etc/apt/sources.list.d/bullseye-backports.list
deb http://deb.debian.org/debian bullseye-backports main contrib non-free
deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free

Подключаем основной для Астра SE 1.7.1 репозиторий Debian Buster (он же Debian 10):

sudo nano /etc/apt/sources.list.d/buster.list
deb http://deb.debian.org/debian/ buster non-free contrib main  
deb-src http://deb.debian.org/debian/ buster main contrib non-free 

deb http://deb.debian.org/debian/ buster-updates main contrib non-free 
deb-src http://deb.debian.org/debian/ buster-updates main contrib non-free 

deb http://security.debian.org/debian-security/ buster/updates main contrib non-free 
deb-src http://security.debian.org/debian-security/ buster/updates main contrib non-free

Подключаем устаревший но пока еще актуальный репозиторий Debian Stretch (Debian 9):

sudo nano /etc/apt/sources.list.d/stretch.list
deb http://deb.debian.org/debian/ stretch non-free contrib main   
deb-src http://deb.debian.org/debian/ stretch non-free contrib main   

deb http://deb.debian.org/debian/ stretch-updates non-free contrib main  
deb-src http://deb.debian.org/debian/ stretch-updates non-free contrib main  

deb http://security.debian.org/debian-security/ stretch/updates non-free contrib main   
deb-src http://security.debian.org/debian-security/ stretch/updates non-free contrib main

Далее уже нестабильный репозиторий, который при необходимости в новых версиях пакетов можно использовать - Debian Testing:
sudo nano /etc/apt/sources.list.d/testing.list
#deb http://deb.debian.org/debian/ testing main contrib non-free 
#deb-src http://deb.debian.org/debian/ testing main contrib non-free 

#deb http://deb.debian.org/debian/ testing-updates main contrib non-free 
#deb-src http://deb.debian.org/debian/ testing-updates main contrib non-free

# А для любителей поиска приключений на свою голову - Debian Sid (я его не использую, и другим не рекомендую). Прописываю здесь только для того что бы было:

sudo nano /etc/apt/sources.list.d/sid.list
# deb http://deb.debian.org/debian/ sid non-free contrib main  
# deb-src http://deb.debian.org/debian/ sid non-free contrib main

# Еще раз повторюсь - эти два последних репозитория только для проверки некоторых моментов на тестовой системе! Без крайней необходимости их применять на рабочей системе категорично не рекомендуется!

# После прописывания всех необходимых системе репозиториев выполняем стандартное обновление системы:

sudo apt update && sudo apt full-upgrade
# Для контроля можно сделать и так (последует перезагрузка системы!):
sudo astra-update -r -A && sudo reboot
```
