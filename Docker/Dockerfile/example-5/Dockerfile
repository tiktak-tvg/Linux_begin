# Базовый образ с которого мы начнём создание своего собственного образа
FROM nginx:1.16.0

# Задаём переменные среды окружения
ENV MODE production
ENV TEST false

# не вызовет в ошибку в отличии от примера example-3
# из-за наличия флага -y который автоматически 
# подтвердит действие
RUN apt-get update \
    && apt-get install curl -y

# ещё одна команда котора создаёт символическу ссылку 
# которая фактически будет выводить log nginx в консоль
RUN ln -sf /dev/stdout /var/log/nginx/access.log


###########################################################
# RUN apt-get update \
#     && apt-get install curl -y \
#     && ln -sf /dev/stdout /var/log/nginx/access.log