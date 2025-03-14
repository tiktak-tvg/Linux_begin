#### Docker
##### Определение
Docker — программное обеспечение для автоматизации развёртывания и управления приложениями в средах с поддержкой контейнеризации.<br>
Virtual Machines предоставляют нам hardware level virtualization в то время как Docker Containers предоставляют operating system level virtualization. 
> Изначально Docker использовал LinuX Containers (LXC)<br>
> Сейчас Docker использует runC (известный как libcontainer)<br>
##### Отличие
> ``Virtual Machine``: состоит из приложения, связанных библиотек и исходного кода и отдельной ОС. Каждая виртуальная машина получает часть ОЗУ и ЦП хост-машины.<br>
> ``Docker Container``: получает своё собственное изолированное пространство, которое содержит само приложение и относящийся к нему исходный код.<br>
![1](https://github.com/user-attachments/assets/bdfe768d-3d4f-41fc-b1e3-9f89edb55cd0)

##### Преимущества
> Портативность<br>
> Быстрая доставка и развёртывание приложений<br>
![2](https://github.com/user-attachments/assets/c420fd6a-6abd-435d-94c2-5b32074c9470)

##### Особенности
- Open-source<br>
- Enterprise<br>
- Cross-platform<br>
- Написан на Go<br>

##### Области применения

- Контейнеризация Web приложений<br>
- Построение отказоустойчивых систем<br>
- Kubernetes<br>
- Тестирование Web приложений<br>
- CI/CD<br>

##### Популярность

- Большие возможности<br>
- Возможность предоставить заказчику готовый продукт<br>
- Огромное комьюнити<br>
- Низкий порог входа<br>
- Малое потребление ресурсов<br>
- Используют миллионы людей во всём мире<br>
- Огромное количество готовых Docker образов<br>

##### Установка на Windows, параметры ОС:

- Windows 10 64bit: Pro, Enterprise or Education (1607 Update, Build 14393 or later)<br>
- Virtualization is enabled in BIOS<br>
- CPU SLAT-capable feature<br>
- At least 4GB of RAM<br>

##### Установка на MacOS, параметры ОС:

- Mac hardware must be a 2010 or newer model<br>
- macOS Sierra 10.12+<br>
- VirtualBox prior to version 4.3.30+ (optional)<br>
- At least 4GB of RAM<br>

##### Установка на Linux, параметры ОС:

- Linux kernel version 3.10 or higher<br>
- 512+ Mb of RAM<br>

##### Что устанавливается:

- ``Docker Engine`` (Windows, macOS, Ubuntu)<br>
- ``Docker CLI`` client (Windows, macOS, Ubuntu)<br>
- ``Docker Compose`` (Windows, macOS)<br>
- ``Docker Machine`` (Windows, macOS, Ubuntu)<br>

###### Определение
``Docker Engine`` — легковесная среда выполнения, которая управляет образами, контейнерами, сборками образов и т.д.<br>
``Docker Daemon`` — демон выполняет команды которые были отправлены клиентом docker. Сборка образов, запуск контейнеров и т.д.<br>
``Dockerfile`` — файл с набором инструкций который используется для сборки образов (docker image).<br>
``Docker Image`` — файл состоящий из множества слоёв, который используется для выполнения кода в докер контейнерах. Read-only template.<br>
``Union File Systems`` — своего рода объединяемая (stackable) файловая система, которая содержит файлы и каталоги разных файловых систем. Они прозрачно накладываются друг на друга, образуя единую файловую систему.<br>
``Docker Volumes`` — часть данных контейнеров которые ссылаются на внешние носители. Перзистентно сохранять данные внутри контейнеров можно только при наличии docker volumes.
``Docker Container`` — это стандартная единица программного обеспечения, которая упаковывает код и все его зависимости. Контейнеры создаются на основе docker image (образов).

###### Как вызвать помощь

- docker --help
- docker docker-subcommand --help

##### Основные команды

Команда         | Описание         | 
----------------|------------------|
attach          |  
build           |    
commit          |    
cp              |   
create          |     
diff            |   
events          | 
exec            | 
export          | 
history         | 
images          | 
import          | 
info            | 
inspect         | 
kill            | 
load            | 
login           | 
logout          | 
logs            | 
pause           | 
port            | 
ps              | 
pull            | 
push            | 
rename          | 
restart         | 
rm              | 
rmi             | 
run             | 
save            | 
search          | 
start           | 
stats           | 
stop            | 
tag             | 
top             | 
unpause         | 
update          | 
version         | 
wait            | 

![3](https://github.com/user-attachments/assets/6e83bd22-d2ff-4fc6-b789-7a2db4015eef)




