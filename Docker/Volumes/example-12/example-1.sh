#!/bin/bash

# Удаляем контейнер
docker container rm -f webhost

# Удаляем все не используемые volume
docker volume prune -f

# "$(pwd)"/html
# /Users/radist/Lectrum Dropbox/Products/Docker/lesson-4/source/2-volumes/example-11/html

docker container run -d \
    --mount type=bind,source="$(pwd)"/html,target=/usr/share/nginx/html,readonly \
    --publish 80:80 \
    --name webhost nginx:alpine