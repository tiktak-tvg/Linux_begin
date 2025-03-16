#!/bin/bash

# Удаляем контейнер
docker container rm -f webhost

# Удаляем все не используемые volume
docker volume prune -f

docker container run -d \
    --mount type=bind,source="$(pwd)"/index.html,target=/usr/share/nginx/html/index.html \
    --mount type=bind,source="$(pwd)"/about.html,target=/usr/share/nginx/html/about.html \
    --publish 80:80 \
    --name webhost nginx:alpine

# For windows
docker container run -d \
    --mount type=bind,source=/"$(pwd)"/index.html,target=/usr/share/nginx/html/index.html \
    --mount type=bind,source=/"$(pwd)"/about.html,target=/usr/share/nginx/html/about.html \
    --publish 80:80 \
    --name webhost nginx:alpine