#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Создаём Volume
docker volume create storage
docker volume create db

# Смотрим информацию о используемых Volume внутри контейнера
docker container run -d -v storage:/data/db mongo

# No OP.
# docker container run -d -v storage:/data/db -v db:/data/db mongo

# No OP
# docker container run -d -v storage:/data/db --name mongo1 mongo
# docker container run -d -v storage:/data/db --name mongo2 mongo