#!/bin/bash

# Удалить всё что не используется
docker system prune -a -f

# Скачиваем пользовательский образ на локальный компьютер
docker image pull fholzer/nginx-brotli

# Получаем подробную информацию про слои
docker image history --no-trunc fholzer/nginx-brotli
