##### Dockerfile
``Dockerfile`` — файл с набором инструкций предназначенный для создания образов.<br>
``Docker`` может автоматически создавать образы, считывая инструкции из ``Dockerfile``.<br>
``Dockerfile`` — это текстовый документ, содержащий все команды, которые пользователь может вызвать в командной строке для сборки образа.

> Dockerfile поддерживает следующие инструкции:

Инструкция      | Описание                                                                                   | 
----------------|--------------------------------------------------------------------------------------------|
ADD	            | Добавьте локальные или удаленные файлы и каталоги.
ARG	            | 	Используйте переменные времени сборки.
CMD	            | 	Укажите команды по умолчанию.
COPY	          | 	Копировать файлы и каталоги.
ENTRYPOINT	    | 	Укажите исполняемый файл по умолчанию.
ENV	            | 	Установите переменные среды.
EXPOSE	        | 	Опишите, какие порты прослушивает ваше приложение.
FROM	          | 	Создайте новый этап сборки из базового образа.
HEALTHCHECK	    | 	Проверка работоспособности контейнера при запуске.
LABEL	          | 	Добавьте метаданные к изображению.
MAINTAINER	    | 	Укажите автора изображения.
ONBUILD	        | 	Укажите инструкции относительно того, когда изображение будет использоваться в сборке.
RUN	            | 	Выполнение команд сборки.
SHELL	          | 	Установить оболочку изображения по умолчанию.
STOPSIGNAL      | 	Укажите системный сигнал вызова для выхода из контейнера.
USER	          | 	Установите идентификатор пользователя и группы.
VOLUME	        | 	Создание монтирований томов.
WORKDIR	        | 	Изменить рабочий каталог.

##### Формат
Инструкция не чувствительна к регистру. Однако принято использовать ЗАГЛАВНЫЕ БУКВЫ, чтобы их было легче отличать от аргументов.

> Пример:

```python
# Comment
INSTRUCTION arguments
```
```python
# Comment
RUN echo 'we are running some # of cool things'
```

Строки комментариев удаляются перед выполнением инструкций Dockerfile. Комментарий в следующем примере удаляется перед тем, как оболочка выполнит echo команду.

> Пример:

```python
RUN echo hello \
world
```

Переменные среды поддерживаются следующим списком инструкций в Dockerfile:

- ADD
- COPY
- ENV
- EXPOSE
- FROM
- LABEL
- STOPSIGNAL
- USER
- VOLUME
- WORKDIR

##### Создать образ
```python
docker build . -t <image name:tag>
docker image build . -t <image name:tag>
```
##### Директивы
```python
escape
syntax
```
##### Пример: доступ к GitLab
```python
# syntax=docker/dockerfile:1
FROM alpine
RUN apk add --no-cache openssh-client
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
RUN --mount=type=ssh \
  ssh -q -T git@gitlab.com 2>&1 | tee /hello
# "Welcome to GitLab, @GITLAB_USERNAME_ASSOCIATED_WITH_SSHKEY" should be printed here
# with the type of build progress is defined as `plain`.
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
(Input your passphrase here)
docker buildx build --ssh default=$SSH_AUTH_SOCK .
```
##### RUN --network
```python
RUN --network=<TYPE>
```
``RUN --network`` позволяет контролировать, в какой сетевой среде выполняется команда.<br>

##### Директивы парсера
```python
Поддерживаются следующие директивы парсера:
syntax
escape
check(начиная с Dockerfile v1.8.0)
```



