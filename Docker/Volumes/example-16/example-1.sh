#!/bin/bash

# Удаляем контейнер
docker container rm -f webhost

# Удаляем все не используемые volume
docker volume prune -f

docker run -d \
  -it \
  --name webhost \
  --mount type=bind,source="$(pwd)"/target,target=/app,readonly \
  nginx:alpine

#OR
# docker run -d \
#   -it \
#   --name webhost \
#   -v "$(pwd)"/target:/app:ro \
#   nginx:alpine