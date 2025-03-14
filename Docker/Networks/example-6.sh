#!/bin/bash

# удалить предыдущий контейнер
docker container rm -f proxy
docker network rm frontend

# Создаём сеть
docker network create frontend

# Запустить контейне с nginx.
# docker container run -d -p 80:80 --name proxy nginx

docker container run -d -p 80:80 --name proxy --net frontend nginx

# Удалить все не используемые сети
docker network prune