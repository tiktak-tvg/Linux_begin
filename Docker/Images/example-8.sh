#!/bin/bash

# Удалить всё что не используется
docker system prune -a -f

# Скачиваем образ на локальный компьютер
docker pull alpine:latest
# Скачает тот же образ что и latest так как 3.9 поседняя текущая верси
docker pull alpine:3.9
# Скачает тот же образ что и latest так как 3.9.3 поседняя текущая верси
docker pull alpine:3.9.3
