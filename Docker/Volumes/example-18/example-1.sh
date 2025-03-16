#!/bin/bash

# Удаляем контейнер
docker container rm -f webhost

# Удаляем все не используемые volume
docker volume prune -f

docker run -d \
  -it \
  --name webhost \
  --mount type=tmpfs,destination=/app,tmpfs-size=100m \
  nginx:alpine