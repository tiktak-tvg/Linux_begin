#!/bin/bash

# удалить предыдущий контейнер
docker container rm -f proxy
docker network rm frontend

# Создаём сеть
docker network create frontend

# Запустить контейне с nginx.
docker container run -d --net frontend --net-alias search elasticsearch:2
docker container run -d --net frontend --net-alias search elasticsearch:2

# nslookup
docker container run --rm --net frontend alpine nslookup search

# curl server info
# docker container run --rm --net frontend centos curl -s search:9200