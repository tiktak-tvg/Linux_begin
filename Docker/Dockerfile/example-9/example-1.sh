#!/bin/bash

# Скачиваем образы для демо
docker image pull nginx:1.16.0

# Создать образ на основании Dockerfile
docker build . -t localhost:5000/nginx:0.0.1

docker run -d -p 80:80 localhost:5000/nginx:0.0.1