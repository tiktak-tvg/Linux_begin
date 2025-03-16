#!/bin/bash

# Удаляем контейнер
docker container rm -f webhost

# Удаляем все не используемые volume
docker volume prune -f

docker run -d \
  -it \
  --name webhost \
  --mount type=tmpfs,destination=/app \
  nginx:alpine

#OR
# docker run -d \
#   -it \
#   --name webhost \
#   --tmpfs /app \
#   nginx:alpine