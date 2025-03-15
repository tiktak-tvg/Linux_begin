##### Docker Image
Docker Image — файл состоящий из множества слоёв, который используется для выполнения кода в докер контейнерах. Read-only template.

![5](https://github.com/user-attachments/assets/55dbb555-6b16-40fa-bdc2-476626269e08)

##### Docker Image Tag
Docker Image Tag — лейбл используемый для версионирования докер образов.

![6](https://github.com/user-attachments/assets/9baa1e45-933b-43cf-bb8b-a6147674a874)

##### Локальные образы
```python
docker images <options> <image name:tag>
docker image ls <options> <image name:tag>
```
##### Закачка образа
```python
docker pull <options> <image name:tag>
docker image pull <options> <image name:tag>
```
##### Продвигаем образ
```python
docker push <options> <image name:tag>
docker image push <options> <image name:tag>
```
##### Информация о образе
```python
docker inspect <options> <image name:tag>
docker image inspect <options> <image name:tag>
```
##### История образа
```python
docker history <options> <image name:tag>
docker image history <options> <image name:tag>
```
##### Версия образа
```python
docker tag <source image name:tag> <image name:tag>
docker image tag <source image name:tag> <image name:tag>
```
