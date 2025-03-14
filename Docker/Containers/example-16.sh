#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём nginx контейнер
# 1. Мапим порт к host машине
# 2. Устанавливаем имя контейнера
docker container create -p 80:80 --name proxy nginx

# Показывает все контейнеры
docker container ps -a