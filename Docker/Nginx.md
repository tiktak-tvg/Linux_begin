#### Nginx

##### Запускаем Nginx
```python
1. docker run - -publish 80:80 nginx
2. docker run -p 80:80 nginx
3. docker container run - -publish 80:80 nginx
4. docker container run -p 80:80 nginx
```
##### Описание команд
1. Загружается образ из Docker Hub
2. Запускает контейнер для этого образа
3. Открывает 80 порт для host IP
4. Перенаправляет трафик на 80−й порт контейнера

##### Прервать соединение Nginx: DETACHED (отсоединить)
```python
docker run - -publish 80:80 - -detach nginx
docker run -p 80:80 -d nginx
docker container run - -publish 80:80 - -detach nginx
docker container run -p 80:80 -d nginx
```

##### Запускаем Nginx по имени хоста
```python
docker run - -name webhost nginx
docker container run - -name webhost nginx
```




