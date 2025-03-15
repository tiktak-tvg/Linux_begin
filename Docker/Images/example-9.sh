#!/bin/bash

# Удалить всё что не используется
docker system prune -a -f

# Скачиваем образ на локальный компьютер
docker pull nginx:latest

# Скачает ту же версию nginx но с другим базовым образом
docker pull nginx:1.15.12-alpine
