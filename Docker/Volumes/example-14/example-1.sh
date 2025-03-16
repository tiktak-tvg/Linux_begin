#!/bin/bash

# Удаляем контейнер
docker container rm -f webhost

# Удаляем все не используемые volume
docker volume prune -f

docker run -d \
  -it \
  --name webhost \
  --mount type=bind,source="$(pwd)"/target,target=/app \
  nginx:alpine

#OR
# docker run -d \
#   -it \
#   --name webhost \
#   --volume "$(pwd)"/target:/app \
#   nginx:alpine

# Всегда создаёт директорию!!!
# docker run -d \
#   -it \
#   --name webhost \
#   --volume "$(pwd)"/target/index.html:/app/index.html \
#   nginx:alpine