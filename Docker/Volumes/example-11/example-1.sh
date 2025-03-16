#!/bin/bash

# Удаляем контейнер
docker container rm -f webhost

# Удаляем все не используемые volume
docker volume prune -f

docker container run -d --mount type=volume,source=storage,target=/usr/share/nginx/html --name webhost nginx:alpine