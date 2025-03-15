#!/bin/bash

# Удалить всё что не используется
docker system prune -a -f

# Скачиваем пользовательский образ на локальный компьютер
docker image pull fholzer/nginx-brotli

# Cоздаём копию образа для third party registry
docker image tag fholzer/nginx-brotli localhost:5000/brotli

# OR
docker image tag fholzer/nginx-brotli sotream.xyz/brotli