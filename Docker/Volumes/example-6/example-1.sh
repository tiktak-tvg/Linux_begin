#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Создаём Volume
docker volume create storage

# Смотрим информацию о используемых Volume внутри контейнера
docker container run -d -v storage:/usr/share/nginx/html:ro -p 80:80 nginx:alpine