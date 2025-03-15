#!/bin/bash

# Скачиваем образ на локальный компьютер
docker pull nginx

# Задаём новое имя образу 
docker image tag nginx sotream/nginx

# Пушим образ в пользовательский репозиторий
docker push sotream/nginx