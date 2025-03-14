#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
docker container run -d -p 80:80 --name proxy nginx

# скопировать файлы и папки внутрь контейнера
docker container cp ./data/*.html proxy:/usr/share/nginx/html
docker container cp ./data/css proxy:/usr/share/nginx/html/css

