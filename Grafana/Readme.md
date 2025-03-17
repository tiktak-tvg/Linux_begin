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
wget https://dl.grafana.com/oss/release/grafana_11.5.2_amd64.deb
устанавливаем пакет
sudo dpkg -i grafana_11.5.2_amd64.deb
sudo apt-cache policy grafana
запускаем
sudo systemctl start grafana-server
проверяем статус
sudo systemctl status grafana-server
```
![image](https://github.com/user-attachments/assets/2af9ab46-596a-4bc1-9da9-07d652b87911)

```python
запустите сервис и добавьте его в автозагрузку
sudo systemctl enable grafana-server
```
![image](https://github.com/user-attachments/assets/a19eb04d-c130-47ca-b075-80ecfc3da3ee)

Чтобы установить соединение, создайте правило для порта 3000 для брандмауэра:
```python
sudo ufw allow 3000/tcp
```
![image](https://github.com/user-attachments/assets/931d47cb-366f-4e77-848d-6f7cfabb46ef)

Войдите в интерфейс. Для этого введите в адресной строке браузера: http://localhost:3000

Откроется стартовая страница. Введите логин и пароль по умолчанию (admin — admin) и нажмите Log in:

![image](https://github.com/user-attachments/assets/07a39737-cb6b-47da-b07e-48013b2d5d53)

Далее предложит поменять пароль

![2](https://github.com/user-attachments/assets/8b6f93e3-c236-4bd1-930e-fae1e7268546)

![2](https://github.com/user-attachments/assets/2d1b9efa-1f26-4773-a246-644d478c33ed)

![image](https://github.com/user-attachments/assets/0b60da92-8fe6-46a8-8c3b-6f41749f0b03)

