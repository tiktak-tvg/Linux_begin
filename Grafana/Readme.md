### Как установить систему мониторинга Grafana на VPS, работающий под управлением Ubuntu 24.04.
Для начала после установки ОС Ubuntu 24.04 обновим репозиторий пакетов apt:
> для Ubuntu и Debian:

```python
sudo apt update
```
> для Fedora и CentOS:

```python
sudo dnf check-update
sudo yum update
```
Обновить установленные пакеты
> для Ubuntu и Debian:

```python
sudo apt upgrade
```
> для Fedora и CentOS:

```python
sudo dnf upgrade
```

Установить все обновления(**не обязательно**)<br>
> для Ubuntu и Debian:

```python
sudo apt full-upgrade
```
> для Fedora и CentOS:

```python
sudo dnf upgrade --best
```
Далее как всё обновили делаем ребут системы ``reboot`` должно получиться типа такого<br>

![image](https://github.com/user-attachments/assets/422d2d5b-59d7-4353-af48-106583b80c51)
> [!Warning]
> При командах на обновление ничего более не требует.

Скачиваем OSS Edition
```python
Лицензия:
AGPLv3
Дата выпуска:
19 февраля 2025 г.
```

Ubuntu и Debian(64-бит)
```python
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/oss/release/grafana_11.5.2_amd64.deb
устанавливаем пакет
sudo dpkg -i grafana_11.5.2_amd64.deb
```

curl https://packagecloud.io/gpg.key | sudo apt-key add -

wget https://dl.grafana.com/oss/release/grafana_11.5.2_amd64.deb
sudo dpkg -i grafana_11.5.2_amd64.deb
sudo apt-cache policy grafana
sudo apt install grafana
запустите сервис и добавьте его в автозагрузку
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
проверьте статус
sudo systemctl status grafana-server
Чтобы установить соединение, создайте правило для порта 3000 для брандмауэра:
sudo ufw allow 3000/tcp
Войдите в интерфейс. Для этого введите в адресной строке браузера: http://localhost:3000
Откроется стартовая страница. Введите логин и пароль по умолчанию (admin — admin) и нажмите Log in:
