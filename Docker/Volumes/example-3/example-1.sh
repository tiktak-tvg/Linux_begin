#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Создаём Volume
docker volume create storage
docker volume create config

# Смотрим информацию о используемых Volume внутри контейнера
docker container run -d -v storage:/data/db -v config:/data/configdb -p 27017:27017 mongo