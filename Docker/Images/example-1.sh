#!/bin/bash

# Скачиваем образы для демо
docker image pull nginx
docker image pull alpine

# Получить список локально скачанных образов
docker image ls

#OR
# docker images