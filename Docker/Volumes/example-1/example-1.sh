#!/bin/bash

# Удаляем все не используемые volume
docker volume prune -f

# Скачиваем образ с MongoDB
docker image pull mongo

# Смотрим информацию о используемых Volume внутри контейнера
# docker image inspect mongo

# OR
docker image inspect mongo --format "{{.Config.Volumes}}"