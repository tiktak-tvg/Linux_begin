#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy
docker rm -f db

# Создаём nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
docker container run -d -p 27017:27017 --name db mongo

# получить логи контейнера
docker container logs db