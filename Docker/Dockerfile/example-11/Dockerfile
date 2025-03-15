# escape=`
# Специальная директива которая опередялет что будет служить
# в качестве символа переноса строки

# Базовый образ с которого мы начнём создание своего собственного образа
FROM nginx:1.16.0

WORKDIR /usr/share/nginx/html

# вызовет ошибку из-за директивы escape
# RUN apt-get update \
#     && apt-get install curl -y

RUN apt-get update `
    && apt-get install curl -y

COPY index.html index.html