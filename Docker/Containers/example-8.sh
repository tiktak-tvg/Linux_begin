#!/bin/bash

# Создаём и запускаем nginx контейнер
# 1. В интерактивном режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
docker container run -p 80:80 --name proxy -i nginx

#OR 
# docker container run -d -p 80:80 --name proxy --interactive nginx