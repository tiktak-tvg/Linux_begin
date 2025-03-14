#!/bin/bash

# удалить предыдущий контейнер
docker container rm -f proxy
docker network rm frontend

# Создаём сеть
docker network create frontend

# Запустить контейне с nginx.
docker container run -d -p 80:80 --name proxy nginx

docker container inspect proxy --format "{{ .NetworkSettings.Networks }}" # one network

# Присоединить контейнер к сети
docker network connect frontend proxy

docker container inspect proxy --format "{{ .NetworkSettings.Networks }}" # two networks

# Отсоединить контейнер от сети
docker network disconnect frontend proxy

docker container inspect proxy --format "{{ .NetworkSettings.Networks }}" # one network