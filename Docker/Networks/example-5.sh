#!/bin/bash

# удалить предыдущий контейнер
docker container rm -f proxy
docker network rm frontend

# Создаём сеть
docker network create frontend

# Запустить контейне с nginx.
# docker container run -d -p 80:80 --name proxy nginx

#OR
# добавляет контенер в определённую сеть
docker container run -d -p 80:80 --name proxy --net frontend nginx

# Получить детальную информацию о сети
docker network inspect frontend