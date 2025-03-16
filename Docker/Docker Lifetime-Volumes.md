##### Docker Bind mount

Bind mount — файл или директория на диске host системы.

> Bind Mount
```python
docker container run -d -v <path to host dir>:/usr/share/nginx/html nginx:alpine
```
> Bind Named
```python
docker container run -d \- -mount type=bind,source=nginx-vol,destination= /usr/share/nginx/html \nginx:alpine
```

##### Docker volume

Docker volume — механизм для постоянного сохранения данных генерируемых и используемых контейнером.
> Docker volume
```python
docker volume create <options> <volume name>
Usage:
docker container run -d -v <volume name>:/container/path nginx
```
> Volume Anonymous
```python
docker container run -d -v /usr/share/nginx/html nginx:alpine
```
> Volume Named
```python
docker container run -d -v <volume name>:/usr/share/nginx/html nginx:alpinee
```
Volume Anonymous
```python
docker container run -d \- -mount destination= /usr/share/nginx/html \nginx:alpine
```
> Volume Named
```python
docker container run -d \- -mount source=nginx-vol,destination= /usr/share/nginx/html \nginx:alpine
```
> Volume Named RO
```python
docker container run -d \- -mount source=nginx-vol,destination= /usr/share/nginx/html,readonly \nginx:alpine
```
> Volume Named
```python
docker container run -d \- -mount type=volume,source=nginx-vol,destination= /usr/share/nginx/html \nginx:alpine
```
> Volume Source or SRC
```python
docker container run -d \- -mount type=volume,source=nginx-vol,destination= /usr/share/nginx/html \nginx:alpine
```

##### TMPFS

TMPFS — механизм для временного сохранения данных генерируемых и используемых контейнером в оперативной памяти host системы.

> TMPFS Named
```python
docker container run -d \- -mount type=tmpfs,destination= /usr/share/nginx/html \nginx:alpine
```

![image](https://github.com/user-attachments/assets/30b48ba8-6b52-46d5-bbd0-5b7b4f0feef9)

##### Команды Docker volume

- create
- inspect
- ls
- prune
- rm

##### Dockerfile volume
```python
FROM nginx:alpine
VOLUME /usr/share/nginx/html
```


