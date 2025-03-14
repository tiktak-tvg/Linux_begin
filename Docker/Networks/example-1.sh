#!/bin/bash

# удалить предыдущий контейнер
docker container rm -f proxy
docker network rm frontend

# Создаём сеть
docker network create frontend

# #OR
# docker network create -d bridge frontend