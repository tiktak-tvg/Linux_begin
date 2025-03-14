#!/bin/bash

# Создаём и запускаем nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
# 4. Устанавливаем хард лимит занимаемой памяти
docker container run -d -p 80:80 --name proxy -m 10485760 nginx

#OR 
# docker container run -d -p 80:80 --name proxy --memroy 10485760 nginx

#NB limit in bytes. 10485760 = 10Mb (10 * 1024 * 1024)