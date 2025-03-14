#!/bin/bash
# удалить предыдущий контейнер
docker rm -f proxy

# Создаём nginx контейнер
# 1. В фоновом режиме
# 2. Мапим порт к host машине
# 3. Устанавливаем имя контейнера
for VARIABLE in 1 2 3
do
	docker container create --name proxy-$VARIABLE nginx
done

# удалить все остановленные контейнеры
docker container prune