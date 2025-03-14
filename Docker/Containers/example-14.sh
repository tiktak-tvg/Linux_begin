#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём и запускаем nginx контейнер
# 1. В интерактивном режиме
# 2. Устанавливаем имя контейнера
# 3. Подключаем псевдо TTY
docker container run -i -t --name proxy ubuntu bash

#OR
# docker container run -it --name proxy ubuntu bash