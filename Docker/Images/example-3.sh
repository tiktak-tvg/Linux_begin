#!/bin/bash

# Скачиваем образы для демо
docker image pull nginx
docker image pull alpine:3.7
docker image pull alpine:2.6

# Получить список локально скачанных образов
docker image ls alpine

#OR
# docker image ls alpine:3.7