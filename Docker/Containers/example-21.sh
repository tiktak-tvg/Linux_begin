#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
docker container run -d -p 80:80 --name proxy1 nginx
docker container run -d -p 8080:80 --name proxy2 nginx

# Получить подробную информацию о контейнере 
docker container rename proxy1 proxy
docker container rename proxy2 webhost