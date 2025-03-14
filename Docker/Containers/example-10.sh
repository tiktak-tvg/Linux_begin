#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём и запускаем nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
# 4. Устанавливаем хард и софт лимит занимаемой памяти
docker container run -d -p 80:80 --name proxy -m 10485760 --memory-reservation 5242880 nginx

# 10485760 = 10Mb
# 5242880 = 5Mb
# --memory-reservation = baseline