#### Nginx

##### Запускаем Nginx
```python
docker run - -publish 80:80 nginx
docker run -p 80:80 nginx
docker container run - -publish 80:80 nginx
docker container run -p 80:80 nginx
```

1. Загружается образ из Docker Hub
2. Запускает контейнер для этого образа
3. Открывает 80 порт для host IP
4. Перенаправляет трафик на 80−й порт контейнера
