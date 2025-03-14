#!/bin/bash

# Создаём и запускаем nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
# 4. Определяем healthcheck
docker container run -d -p 80:80 --name proxy --health-cmd 'curl http://localhost:80/' --health-retries 3 --health-interval '1s' nginx

# Для того что бы исправить статус на healthy необходимо установить в контейнере curl.
# apt-get update && apt-get install curl -y