#!/bin/bash

# Создаём и запускаем nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
docker container run -d -p 80:80 nginx

# OR
# docker container run --detached --publish 80:80 nginx