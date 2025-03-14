#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
docker container run -d -p 80:80 --name proxy nginx

# Получить отформатированную информацию о контейнере 
docker container inspect proxy --format "IP: {{ .NetworkSettings.IPAddress }} | Gateway: {{.NetworkSettings.Networks.bridge.Gateway}}"