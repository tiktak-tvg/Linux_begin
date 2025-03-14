#!/bin/bash
# удалить предыдущий контейнер
docker container rm -f proxy

# Создаём и запускаем nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
# 4. Устанавливаем политику рестарта контейнера 
docker container run -d -p 80:80 --name proxy --restart always nginx

# no — default
# on-failure — перезагрузить в случае ошибки
# always — всегда перезагружать
# unless-stopped — пока контейнер не будет остановлен