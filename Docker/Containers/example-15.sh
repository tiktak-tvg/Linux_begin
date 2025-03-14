#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy # proxy

# Создаём nginx контейнер
# 1. Мапим порт к host машине
# 2. Устанавливаем имя контейнера
docker container create -p 80:80 --name proxy nginx # 09b5b111388f12b06ddead99ae648718fe0086acd331c28e7ccf14bdabab7ab9

# Показывает только запущенные контейнеры
docker container ps