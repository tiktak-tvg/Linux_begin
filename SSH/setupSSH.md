#### Установка ssh на Ubuntu/Debian.

sudo apt update 

sudo apt install ssh

sudo apt install openssh-server

sudo systemctl enable --now ssh

sudo systemctl status ssh

sudo systemctl enable ssh

sudo systemctl stop ssh

sudo systemctl start ssh

##### Меняем порт.

sudo nano /etc/ssh/sshd_config

port 2212

sudo systemctl restart sshd

sudo systemctl status ssh


##### Отключение.

sudo systemctl disable ssh --now

##### Подключение через powershell
ssh имя пользователя@192.168.133.128 -p 2212

#### Установка ssh на Centos.

```
yum install epel-release
sudo apt update
```

Устанавливаем если не установили при загрузке программу.<br>
```
sudo apt install ssh
sudo apt install openssh-server
```

Устанавливаем пакет который нам понадобиться для замены порта на ssh.<br>
```
yum install policycoreutils-python
```
Порверим статус ssh.<br>
```
sudo systemctl status ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/af7833c7-e519-4753-82e9-7c87c1c7f558)

Назначим в автозагрузку службу.<br>
```
sudo systemctl enable ssh
sudo systemctl stop ssh
sudo systemctl start ssh
```

##### Как поменять порт.

Немного посложнее, чем на Ubuntu.<br>
Смотрим через какой порт сейчас работает ssh, по умолчанию 22.<br>
```
sudo semanage port -l | grep ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/0c7e9c1e-4273-4aeb-8137-816871efeb12)

Задаём новый порт, например 2255. <br>
```
sudo semanage port -a -t ssh_port_t -p tcp 2255
```

Проверяем, что добавился.<br>
```
sudo semanage port -l | grep ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/7fcbf9ee-d3f5-4cc2-9286-43fa8f565018)

Смотрим какие порты у нас открыты в файерволе.<br>
```
firewall-cmd --list-ports
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/43958ecf-0e17-4084-aeb9-610c95dee388)

Далее, делаем разрешение на этот порт в файерволе и применяем изменение. <br>
```
firewall-cmd --zone=public --add-port=2255/tcp --permanent
firewall-cmd --reload
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ce03d1a9-4fce-4e8a-b1c2-f407cd0c6024)

Перезагружаем службу, можно этого не делать, просто хочу показать, что на ssh порт ещё не поменялся.<br>

```
sudo systemctl restart sshd
```

И видим, что в файерволе он открыт ``Connection refused``.<br>
![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/7672d63d-7516-42d8-b570-e5ab80653ae7)

```
sudo systemctl status ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/6f4c6393-e37c-47ca-b019-077c38d5087d)

Проверяем соединение, его до сих пор нет.<br>

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/b6ae4157-2266-4ee7-9d22-cc6307d87cb1)

Для окончательной замены порта, редактируем файл ``nano /etc/ssh/sshd_config``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/cfaf1c7e-2202-4550-a5b3-b5be70085ff3)

Теперь всё работает. Соединение проходит по другому порту 2255.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/73c2123a-aed4-4de0-8e4b-c99b266ddd06)

Подключение по порту 22 не работает.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/0f41f1cd-b79e-4cef-867f-c6b583245871)

И в статусе он нам теперь показывает правильный порт на который мы его поменяли.<br>

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/a0334310-8c9e-47ea-be05-e905d633218b)

Сохранить все изменения в файерволе сделав их постоянными.<br>

```
firewall-cmd --runtime-to-permanent
```

Можно поменять порт в службе ssh в файерволе, по умолчанию он так и остался 22 и открыт.<br>
Закрываем порт, редактируем службу ssh.

```
Все службы находятся здесь ls /usr/lib/firewalld/services/
Нам нужна ssh.xml
Редактируем.
nano /usr/lib/firewalld/services/ssh.xml
```
Получаем результат.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/5458d19c-f68f-40df-bc19-2f1175435ee5)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/0263ff33-2612-4321-94a9-8543d4ee85a6)
                                                            





