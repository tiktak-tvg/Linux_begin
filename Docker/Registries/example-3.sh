#!/bin/bash

# Скачиваем образ на локальный компьютер
docker pull nginx

# Задаём новое имя образу (локальный registry)
docker image tag nginx localhost:5000/nginx

# Пушим образ в пользовательский репозиторий
docker push localhost:5000/nginx

# Путь по которому сохраняются образы в локальном репозитории 
# /var/lib/registry/docker/registry/v2