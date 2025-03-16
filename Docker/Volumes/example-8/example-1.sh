#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Создаём Volume
docker volume create --driver local \
    --opt type=tmpfs \
    --opt device=tmpfs \
    --opt o=size=100m \
    storage

docker container run -d -v storage:/data/db --name mongo mongo

# OR
# docker container run -d --volume storage:/data/db --name mongo mongo