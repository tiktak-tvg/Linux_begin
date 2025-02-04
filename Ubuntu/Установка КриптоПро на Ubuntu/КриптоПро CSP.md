##### ﻿Установка КриптоПРО CSP 

Описание процесса установки приведено на примере дистрибутива семейства Debian (x64).

Некоторые команды могут потребовать запуска с sudo.

Названия файлов и директорий могут отличаться из-за различий в версиях.

Загрузите КриптоПро CSP версии 4.0 для Вашей платформы и распакуйте архив:
```bash
tar -xzvf linux-amd64_deb.tgz
```

Для установки выполните команды:
```bash
sudo chmod 777 -R linux-amd64_deb/
sudo linux-amd64_deb/install.sh
```

Проверьте отсутствие cprocsp-rdr-gui:
```bash
dpkg -l | grep cprocsp-rdr
```

Установите дополнительно cprocsp-rdr-gui-gtk:
```bash
sudo dpkg -i linux-amd64_deb/cprocsp-rdr-gui-gtk-64_4.0.0-4_amd64.deb
```

Установите лицензионный ключ командой:
```bash
sudo /opt/cprocsp/sbin/amd64/cpconfig -license -set XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

###### Информация по установке КриптоПро CSP

1. устанавливаем необходимые стандартные библиотеки

Сначала необходимо поставить(если не установлены) пакеты LSB из состава дистрибутива, а также пакет alien, который является штатным средством для установки .rpm:
```bash
apt-get install lsb-base alien lsb-core
```

Затем при помощи alien поставить необходимые пакеты CSP, например:
```bash
alien -kci ./lsb-cprocsp-base-3.6.4-4.noarch.rpm
alien -kci ./lsb-cprocsp-rdr-3.6.4-4.i486.rpm
alien -kci ./lsb-cprocsp-kc1-3.6.4-4.i486.rpm
alien -kci ./lsb-cprocsp-capilite-3.6.4-4.i486.rpm
```

2. Качаем КриптоПро CSP 4.0R2 linux x64 предварительно зарегистрировавшись

3. Распаковываем и устанавливаем
```bash
Код:
cd ~/Downloads
tar -xf linux-amd64_deb.tgz
cd linux-amd64_deb
sudo ./install.sh
```

а затем 

###### GUI элементы для работы с сертификатами
```bash
sudo dpkg -i cprocsp-rdr-gui-gtk-64_4.0.0-4_amd64.deb 
```

###### Качаем плагин версии 2.0 предварительно зарегистрировавшись, копируем файл libnpcades.so в папку с плагинами

4. готово

> p.s. удалить можно выполнив код в этой же директории:

Как  удалить КриптоПро:
```bash
sudo ./uninstall.sh
sudo rm -rf /opt/cprocsp
sudo rm -rf /etc/opt/cprocsp
sudo rm -rf /var/opt/cprocsp
sudo rm /opt/google/chrome/extensions/iifchhfnnmpdbibifmljnfjhpififfog.json
sudo rm /etc/chromium/native-messaging-hosts/ru.cryptopro.nmcades.json
sudo rm /etc/opt/chrome/native-messaging-hosts/ru.cryptopro.nmcades.json
sudo rm /usr/lib/firefox-addons/plugins/libnpcades.so
sudo rm /usr/share/chromium-browser/extensions/iifchhfnnmpdbibifmljnfjhpififfog.json
sudo rm /usr/share/chromium/extensions/iifchhfnnmpdbibifmljnfjhpififfog.json
```

Вы можете протестировать работу, используя тестовый серверный сертификат, полученный в нашем тестовом удостоверяющем центре:

> по ГОСТ 2001 - https://www.cryptopro.ru/certsrv/
> 
> по ГОСТ 2012 - https://testgost2012.cryptopro.ru/certsrv/

Чтобы в расширении Альтернативное имя субъекта сертификата сервера были записаны нужные DNS имена, нужно в форме запроса на сертификат в веб-интерфейсе в поле Атрибуты указать значение вида (несколько DNS имен указываются через символ &):
```bash
Код:
san:dns=domain1.ru&dns=domain2.ru
```

###### Установка тестовых сертификатов
> 1. Качаем корневой сертификат
> 2. Устанавливаем его
```bash
Код:
/opt/cprocsp/bin/amd64/certmgr -inst -store uroot -file certnew.cer
```

Смотрим доступные контейнеры
```bash
Код:
/opt/cprocsp/bin/amd64/csptest -keyset -enum_cont -verifycontext -fqcn
```

Устанавливаем сертификат:
```bash
Код:
/opt/cprocsp/bin/amd64/certmgr -inst -store umy -file ~/Downloads/test\ 8.12.2016\ KC1\ CSP.pem -cont '\\.\HDIMAGE\70275af7-e10b-bed3-b1b3-88641f09f3a5'
```

Инструкция по установке КриптоПро Browser Plug-In 2.0 в Firefox v50.0.2
> 1. Качаем плагин версии 2.0
> 2. Распаковывем и устанавливаем
```bash
Код:
cd ~/Загрузки
mkdir cades_linux_amd64
tar -xf cades_linux_amd64.tar.gz -C cades_linux_amd64
cd cades_linux_amd64
sudo alien -kci cprocsp-pki-2.0.0-amd64-cades.rpm
sudo alien -kci cprocsp-pki-2.0.0-amd64-plugin.rpm
# С первого раза не все файлы копируются, например не копируется /opt/cprocsp/lib/amd64/libnpcades.so
sudo alien -kci cprocsp-pki-2.0.0-amd64-plugin.rpm
```

3. Копируем файл libnpcades.so в папку с плагинами
```bash
Код:
sudo cp /opt/cprocsp/lib/amd64/libnpcades.so /usr/lib/firefox-addons/plugins/libnpcades.so
```

4. Перезапускаем/запускаем firefox

5. Открываем about:addons

6. Выбираем вкладку Plugins.

7. У плагина CryptoPro CAdES plugin ставим значение Always Activate

8. Проверяем работоспособность на demo странице, либо на странице генерации тестового сертификата

Инструкция по установке КриптоПро Browser Plug-In 2.0 в Google Chrome 54.0.2840.100 (64-bit)

Выполняем, если не выполнены пункты 1 и 2 из предыдущего раздела.

Устанавливаем плагин из магазина: CryptoPro Extension for CAdES Browser.

Дополнительная информация

Если на демо странице пишет что-то вроде:
```bash
Код:
Ошибка при открытии хранилища: The system cannot find the file specified. (0x80070002)
```

Значит у вас не установлено ни одного сертификата.

Список установленных компонентов:
```bash
Код:
dpkg -l | grep csp
```

Вывод установленных сертификатов:
```bash
Код:
/opt/cprocsp/bin/amd64/certmgr -list
```

Установка корневого сертификата УЦ:
```bash
Код:
sudo /opt/cprocsp/bin/amd64/certmgr -inst -store uroot -file путь_к_файлу_с_сертификатом
```

Перечисление доступных контейнеров:
```bash
Код:
/opt/cprocsp/bin/amd64/csptest -keyset -enum_cont -verifycontext -fqcn
```

Установка личного сертификата:
```bash
Код:
/opt/cprocsp/bin/amd64/certmgr -inst -store umy -file путь_к_файлу_с_сертификатом -cont 'имя_контейнера'
```

Если в контейнере присутствует сертификат, то для его установки личного сертификата можно использовать команды:
```bash
Код:
/opt/cprocsp/bin/amd64/certmgr -inst -cont 'имя_контейнера'
```

Установить все сертификаты в хранилище Личное uMy из доступных контейнеров:
```bash
Код:
/opt/cprocsp/bin/amd64/csptestf -absorb -certs
```

Добавление хранилища на жёстком диске:
```bash
Код:
sudo /opt/cprocsp/sbin/amd64/cpconfig -hardware reader -add HDIMAGE store
```

Генерация пары закрытого/открытого ключа в хранилище:
```bash
Код:
/opt/cprocsp/bin/amd64/csptest -keyset -newkeyset -cont '\\.\HDIMAGE\main' -provtype 75 -provider "Crypto-Pro GOST R 34.10-2001 KC1 CSP"
```

Создание запроса на подпись сертификата:
```bash
Код:
/opt/cprocsp/bin/amd64/cryptcp -creatrqst -dn "E=email, C=RU, CN=localhost, SN=company" -nokeygen -both -ku -cont '\\.\HDIMAGE\main' main.req
```

Загрузка подписанного сертификата к паре закрытого/открытого ключа:
```bash
Код:
/opt/cprocsp/bin/amd64/certmgr -inst -file main.cer -store umy -cont '\\.\HDIMAGE\main'
```
