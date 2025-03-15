# Базовый образ с которого мы начнём создание своего собственного образа
FROM nginx:1.16.0

ENV WORKDIR /usr/share/nginx/html

WORKDIR ${WORKDIR}

COPY index.html index.html

COPY . .