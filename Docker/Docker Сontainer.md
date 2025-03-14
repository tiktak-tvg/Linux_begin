#### Docker Сontainer
``Docker Container`` — это стандартная единица программного обеспечения, которая упаковывает код и все его зависимости. Контейнеры создаются на основе docker image (образов).

![4](https://github.com/user-attachments/assets/ed76734f-2f3e-45ba-bc87-96aa2c47a9ea)

##### Проверяем версию
```python
docker version
```
##### Проверяем конфиг
```python
docker info
```
##### Проверяем REGISTRY
```python
→ docker run - -rm hello-world
→ docker container run - -rm hello-world
```
##### Создаём контейнер 
```python
docker create <options> <image name:tag>
docker container create <options> <image name:tag>
```
##### Container info
```python
docker ps <options>
docker container ls <options>
```
##### Container stats
```python
CONTAINER ID — идентификатор контейнера
IMAGE — образ на основании которого был создан контейнер
COMMAND — команда которая используется как основной процесс
CREATED — время когда был создан контейнер
STATUS — статус контейнера (запащен, на пазуе, остановлен с ошибкой и т.д.)
PORTS — внутренние порты и мапинг портов
NAMES — имя контейнера
```
##### Remove Container
```python
docker rm <options> <container name> or <hash>
docker container rm <options> <container name> or <hash>
```
##### Stop Container
```python
docker stop <container name> or <hash>
docker container stop <container name> or <hash>
```
##### Pause Container
```python
docker pause <container name> or <hash>
docker container pause <container name> or <hash>
```
##### Start Container
```python
docker start <container name> or <hash>
docker container start <container name> or <hash>
```
##### Unpause Container
```python
docker unpause <container name> or <hash>
docker container unpause <container name> or <hash>
```
##### Inspector Container
```python
docker inspect <container name> or <hash>
docker container inspect <container name> or <hash>
```
##### Container Processes
```python
docker top <container name> or <hash>
docker container top <container name> or <hash>
```
##### Container Stats
```python
docker stats
docker container stats>
```







