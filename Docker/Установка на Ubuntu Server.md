1. Сначала обновите существующий список пакетов:
```python
sudo apt update
```

2. Установите несколько обязательных пакетов, которые позволят apt использовать пакеты по HTTPS:
```python
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

3. Добавьте ключ GPG для официального репозитория Docker:
```python
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

4. Добавьте репозиторий Docker в источники APT:
```python
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
```

5. Обновите базу данных пакетов, добавив в нее пакеты Docker из недавно добавленного репозитория:
```python
sudo apt update
```

6. Убедитесь, что вы собираетесь выполнить установку из репозитория Docker, а не из репозитория Ubuntu по умолчанию:
```python
apt-cache policy docker-ce
```

7. Устанавливаем докер
```python
sudo apt-get install docker-ce
```

8. Проверьте, работает ли он
```python
sudo systemctl status docker
```

9. Необязательные шаги (разрешить запуск команд Docker без sudo):
> Добавьте свое имя пользователя в группу Docker
> 
```python
sudo usermod -aG docker ${USER}
Проверяем
sudo systemctl stop docker
[user@hostname]$systemctl start docker
```
