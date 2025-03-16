#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Создаём Volume
docker volume create storage
docker volume create config

# Смотрим информацию о используемых Volume внутри контейнера
docker container run -d -v storage:/data/db -v config:/data/configdb -p 27017:27017 mongo

# Контейнер не будет запущен так как Volume уже используется
docker container run -d -v storage:/data/db -v config:/data/configdb -p 27018:27017 mongo

# 2019-05-02T17:28:29.479+0000 I STORAGE  [initandlisten] exception in initAndListen: DBPathInUse: Unable to lock the lock file: /data/db/mongod.lock (Unknown error). Another mongod instance is already running on the /data/db directory, terminating
# 2019-05-02T17:28:29.479+0000 I NETWORK  [initandlisten] shutdown: going to close listening sockets...