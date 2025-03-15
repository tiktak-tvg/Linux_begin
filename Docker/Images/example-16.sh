#!/bin/bash

# Удалить всё что не используется
docker system prune -a -f

# Скачиваем пользовательский образ на локальный компьютер
docker image pull fholzer/nginx-brotli

# Cоздаём копию образа для docker hub registry
docker image tag fholzer/nginx-brotli sotream/brotli
docker image tag fholzer/nginx-brotli sotream/brotli:0.0.1
