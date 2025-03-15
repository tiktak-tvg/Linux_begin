# Базовый образ с которого мы начнём создание своего собственного образа
FROM nginx:1.16.0

ENV WORKDIR /usr/share/nginx/html

# Домашний каталог
WORKDIR ${WORKDIR}

# Добавить мета информацию к образу
LABEL version="1.0" \
      maintainer="Lectrum LLC"

COPY index.html index.html