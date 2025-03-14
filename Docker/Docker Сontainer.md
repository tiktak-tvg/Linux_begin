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
