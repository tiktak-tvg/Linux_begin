#!/bin/bash

# Создаём и запускаем nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
docker container run -d -p 80:80 --name proxy nginx

#  Вернёт ошибку так как имя контейнера должно быть уникальным
docker container run -d -p 8080:80 --name proxy nginx