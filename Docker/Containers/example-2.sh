#!/bin/bash

# Создаём и запускаем nginx контейнер
# 1. в фоновом режиме
docker container run -d nginx

# OR
# docker container run --detached nginx