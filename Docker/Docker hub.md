##### Docker hub
``Docker hub`` — облачное хранилище предназначенное для создания публичных и приватных репозиториев для образов.<br> 
Репозиторий для работ с Docker по умолчанию.

- Самый популярный публичный репозиторий докер образов
- На самом деле это репозиторий докер с надстройкой для авто-сборки образов
- Возможность подключит GitHub/BitBucket к Docker Hub для авто-сборки
- Создавать цепочки для сборки образов

##### Docker Store
``Docker Store`` — магазин, где можно приобрести или купить подписку на официальные, сертифицированные образы.  

##### Docker Registry
``Docker Registry`` — репозиторий для хранения докер образов.
> Пример:
```python
docker container run -d -p 5000:5000 - -restart always - -name registry registry:2
```
###### push to Registry
> Пример:
```python
docker push localhost:5000/ubuntu
```
##### Сторонние реестры 
- Облако(Cloud): AWS, Azure, Google Cloud
- Собственное размещение(Self-hosted): Docker EE, Quay Enterprise, GitLab
