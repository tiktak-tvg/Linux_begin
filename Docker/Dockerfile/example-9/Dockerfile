# Базовый образ с которого мы начнём создание своего собственного образа
FROM nginx:1.16.0

WORKDIR /usr/share/nginx/html
#OR → но это плохая практика
# RUN cd /usr/share/nginx/html

COPY index.html index.html
#  если индексный файл находится в папке build
# COPY ./build/index.html index.html

# эти команды определять не нужно
# они присутствуют в базовом образе → FROM
# EXPOSE
# CMD