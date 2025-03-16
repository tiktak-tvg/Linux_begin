#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Создаём Volume
docker volume create storage
docker volume create config

# Смотрим информацию о используемых Volume внутри контейнера
docker container run -d -v storage:/data/db:ro -v config:/data/configdb -p 27017:27017 mongo

# 2019-05-02T17:30:38.521+0000 I STORAGE  [initandlisten] exception in initAndListen: DBPathInUse: Unable to create/open the lock file: /data/db/mongod.lock (Unknown error). Ensure the user executing mongod is the owner of the lock file and has the appropriate permissions. Also make sure that another mongod instance is not already running on the /data/db directory, terminating
# 2019-05-02T17:30:38.521+0000 I NETWORK  [initandlisten] shutdown: going to close listening sockets...