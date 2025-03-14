#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
CONTAINER_ID=$(docker container run -d -p 80:80 --name proxy nginx)

# Создать новый образ на основании контейнера 
docker container commit --author "Andrey Prisniak aprisniak@lectrum.io" --message "Add curl" "$CONTAINER_ID" sotream/nginx-curl:0.0.1