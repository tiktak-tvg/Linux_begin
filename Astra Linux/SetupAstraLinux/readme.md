##### Установка Astra Linux с поддержкой AD.

Скачаваем файл ISO, по рекомендации это версии  

Версии такие с 1.7.4-24.04.2023_14.23 до 1.7.6.15-15.11.24_17.20 Смоленск

Устанавливаем.

Подключим репозитории

Подключение репозиториев. Файлы программ Linux объединяются в пакеты и распространяются через специальные хранилища, называемые репозиториями. Основным файлом для хранения списка доступных репозиториев является /etc/apt/sources.list, дополнительные списки могут храниться в файлах *.list в директории /etc/apt/sources.list.d/. По умолчанию Astra Linux предлагает использовать репозитории stable, которые соответствуют последней версии операционной системы, но для работы с ALD Pro требуется переключить репозитории на frozen, чтобы гарантировать полную совместимость пакетов. Обязательными для версии ALD Pro 2.2.1 являются репозитории base и aldpro. В репозитории base продублированы репозитории main и update, поэтому можно указывать base вместо main и update. Пакеты из репозитория extended продублированы в репозитории aldpro, поэтому в данном случае репозиторий extended можно не указывать. Т.е. нужно указать репозитории или main + update + aldpro или base + aldpro.<br>
Переходим в редактор файла

``nano /etc/apt/sources.list``

```bash
# Astra Linux repository description https://wiki.astralinux.ru/x/0oLiC
# Основной репозиторий
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-main/     1.7_x86-64 main contrib non-free
# Оперативные обновления основного репозитория
deb https://dl.astralinux.ru/astra/stable/1.7_x86-64/repository-update/   1.7_x86-64 main contrib non-free

#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-main/ 1.7_x86-64 main contrib non-free
#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-update/ 1.7_x86-64 main contrib non-free

#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-base/ 1.7_x86-64 main contrib non-free
#deb https://download.astralinux.ru/astra/stable/1.7_x86-64/repository-extended/ 1.7_x86-64 main contrib non-free

deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-base/          1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/repository-extended/      1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-base/     1.7_x86-64 main contrib non-free
deb https://dl.astralinux.ru/astra/frozen/1.7_x86-64/1.7.3/uu/2/repository-extended/ 1.7_x86-64 main contrib non-free
```
```bash
apt update
apt dist-upgrade
```

P.s. Не буду заострять на этом внимание.

Далее, настройка.
