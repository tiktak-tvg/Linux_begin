##### Docker hub
``Docker hub`` — облачное хранилище предназначенное для создания публичных и приватных репозиториев для образов.<br> 
Репозиторий для работ с Docker по умолчанию.

![1](https://github.com/user-attachments/assets/4ff37875-5187-435f-85bf-f7c01ad0db36)

- Самый популярный публичный репозиторий докер образов
- На самом деле это репозиторий докер с надстройкой для авто-сборки образов
- Возможность подключит GitHub/BitBucket к Docker Hub для авто-сборки
- Создавать цепочки для сборки образов

##### Docker Store
``Docker Store`` — магазин, где можно приобрести или купить подписку на официальные, сертифицированные образы.  

![2](https://github.com/user-attachments/assets/9e2a8e13-e046-4b63-a4c1-98c07719f5d2)

##### Docker Registry
``Docker Registry`` — репозиторий для хранения докер образов.

![3](https://github.com/user-attachments/assets/2e2ef07b-d375-4207-956b-48d651da619d)

> Пример:
```python
docker container run -d -p 5000:5000 - -restart always - -name registry registry:2
```
###### push to Registry(отправить в реестр)
> Пример:
```python
docker push localhost:5000/ubuntu
```
##### Third party Registres(реестры третьих лиц) 

![4](https://github.com/user-attachments/assets/82e727f6-0cdc-45af-8431-af24335e39a8)

- Облако(Cloud): AWS, Azure, Google Cloud
- Собственное размещение(Self-hosted): Docker EE, Quay Enterprise, GitLab
