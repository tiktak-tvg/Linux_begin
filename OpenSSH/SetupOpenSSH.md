#### Установка ssh на Ubuntu/Debian.

```
sudo apt update 
sudo apt install ssh
sudo apt install openssh-server
sudo systemctl enable --now ssh
sudo systemctl status ssh
sudo systemctl enable ssh
sudo systemctl stop ssh
sudo systemctl start ssh
```
![1](https://github.com/user-attachments/assets/74c617ed-ee15-4904-96c8-5bc4cbe3272e)

На рисунке видим порт по умолчанию 22 и сервер OpenSSH запущен

##### Меняем порт.

Редактируем редактором nano, кто хочм редактором по умолчанию vim файл sshd_config по пути /etc/ssh/sshd_config

И меняем порт 22 на 2212 например

![image](https://github.com/user-attachments/assets/3267ffeb-8254-4b54-b005-be73abf39a77)

![image](https://github.com/user-attachments/assets/11b2fcee-60cc-4cf6-bb0d-28fd42d168fb)

Сохраняем и перегружаем сервер OpenSSH

```
sudo nano /etc/ssh/sshd_config
port 2212
sudo systemctl restart sshd
sudo systemctl status ssh
```
![image](https://github.com/user-attachments/assets/0483217e-62f9-4a87-a2a1-b4c6f4e4adda)

##### Подключение через powershell
```python
ssh имя пользователя@192.168.133.128 -p 2212
```
##### Подключение через cmd
```python
ssh имя пользователя@192.168.133.128 -p 2212
```
![image](https://github.com/user-attachments/assets/93564464-535c-475a-8a82-9a84ffa71abb)

##### Подключение через MobaXTern
![image](https://github.com/user-attachments/assets/26fc2b2a-fbe6-462b-b2f3-fb8e7f118499)

![image](https://github.com/user-attachments/assets/19e42307-6e42-4a16-aa11-86aba57df6f3)

##### Если надо сделать отключение.
```python
sudo systemctl disable ssh --now
```

##### Настройка файервола.
```python
sudo ufw status verbose
```

##### Разрешить входящие SSH-соединения, выполните команду:
```python
sudo ufw allow ssh
```

##### Если использует другой порт, вам необходимо указать его в явном виде:
```python
sudo ufw allow 2212
sudo ufw enable
```

##### Если запретить 22 порт, то так:
```python
sudo ufw deny 22
```
##### Безопасный OpenSSH на Ubuntu

Одним из рекомендуемых способов защиты сервера при использовании OpenSSH, это отключить логин Root<br>

```python
sudo nano /etc/ssh/sshd_config
#PermitRootLogin yes
или
PermitRootLogin no
```
И создать другого пользователя
```python
sudo adduser userssh
sudo usermod -aG sudo userssh
sudo usermod -aG ssh userssh
```
![image](https://github.com/user-attachments/assets/39edc750-d6d7-4e26-b13a-1381a442e8a1)

#### Установка ssh на Centos.

Для начала. Cделаем пакеты из дистрибутива Fedora Linux доступными для использования в дистрибутиве RHEL и его производных.<br> 
И обновим пакеты.

```python
yum install epel-release
sudo apt update
```

##### Устанавливаем если не установили при загрузке программу.<br>
```python
sudo apt install ssh
sudo apt install openssh-server
```
##### Первый вариант.
##### Устанавливаем пакет который нам понадобиться для добавления порта на ssh через semanage.<br>
```python
yum install policycoreutils-python
sudo semanage port -l | grep ssh
```
Проверим статус ssh.<br>
```python
sudo systemctl status ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/af7833c7-e519-4753-82e9-7c87c1c7f558)

##### Назначим в автозагрузку службу.<br>
```python
sudo systemctl enable ssh
sudo systemctl stop ssh
sudo systemctl start ssh
```

#### Как поменять порт?

Немного посложнее, чем на Ubuntu.<br>
##### Смотрим через какой порт сейчас работает ssh, по умолчанию 22.<br>
```python
sudo semanage port -l | grep ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/0c7e9c1e-4273-4aeb-8137-816871efeb12)

##### Задаём новый порт, например 2255. <br>
```python
sudo semanage port -a -t ssh_port_t -p tcp 2255
```

##### Проверяем, что добавился.<br>
```python
sudo semanage port -l | grep ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/7fcbf9ee-d3f5-4cc2-9286-43fa8f565018)

##### Смотрим какие порты у нас открыты в файерволе.<br>
```python
firewall-cmd --list-ports
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/43958ecf-0e17-4084-aeb9-610c95dee388)

##### Далее, делаем разрешение на этот порт в файерволе и применяем изменение. <br>
```python
firewall-cmd --zone=public --add-port=2255/tcp --permanent
firewall-cmd --reload
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ce03d1a9-4fce-4e8a-b1c2-f407cd0c6024)

##### Перезагружаем службу, можно этого не делать, просто хочу показать, что на ssh порт ещё не поменялся.<br>
```python
sudo systemctl restart sshd
```

##### И видим, что в файерволе он открыт ``Connection refused``.<br>
![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/7672d63d-7516-42d8-b570-e5ab80653ae7)

```python
sudo systemctl status ssh
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/6f4c6393-e37c-47ca-b019-077c38d5087d)

##### Проверяем соединение, его до сих пор нет.<br>

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/b6ae4157-2266-4ee7-9d22-cc6307d87cb1)

##### Для окончательной замены порта, редактируем файл ``nano /etc/ssh/sshd_config``

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/cfaf1c7e-2202-4550-a5b3-b5be70085ff3)

##### Теперь всё работает. Соединение проходит по другому порту 2255.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/73c2123a-aed4-4de0-8e4b-c99b266ddd06)

##### Подключение по порту 22 не работает.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/0f41f1cd-b79e-4cef-867f-c6b583245871)

##### И в статусе он нам теперь показывает правильный порт на который мы его поменяли.<br>

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/a0334310-8c9e-47ea-be05-e905d633218b)

##### Сохранить все изменения в файерволе сделав их постоянными.<br>
```python
firewall-cmd --runtime-to-permanent
```

##### Второй вариант.
##### Можно поменять порт в службе ssh в файерволе, по умолчанию он так и остался 22 и открыт.<br>
##### Закрываем порт, редактируем службу ssh.

```python
Порт можно закрыть так firewall-cmd --zone=public --remove-port=22/tcp --permanent
Либо правилом firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address="192.168.x.x" port port=22 protocol=tcp reject'
firewall-cmd --list-rich-rules
firewall-cmd --reload
```

##### Если требуется удалить правило.
```python
firewall-cmd --permanent --remove-port=22/tcp
```

##### Меняем порт на службе в ручную.
```python
Все службы находятся здесь ls /usr/lib/firewalld/services/
Нам нужна ssh.xml
Редактируем.
nano /usr/lib/firewalld/services/ssh.xml
Меняем порт 22 на 2255
```

##### Или через команду.
```python
sudo firewall-cmd --service=ssh --remove-port=22/tcp --permanent    закрываем порт
sudo firewall-cmd --service=ssh --add-port=2255/tcp --permanent     меняем на новый порт
sudo firewall-cmd --reload                                          применяем настройки
sudo firewall-cmd --info-service=ssh                                выводим информацию
```

##### Получаем результат.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/5458d19c-f68f-40df-bc19-2f1175435ee5)

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/0263ff33-2612-4321-94a9-8543d4ee85a6)
                                                            
По умолчанию брандмауэр работает без каких-либо правил.<br> 
В приведенном ниже примере показано, как просмотреть список правил.

```python
iptables-save | tail -n3
iptables-save | tail -n4...  можно перебирать последние записи
iptables -L -n   а можно сразу посмотреть
iptables-save | less  или так
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/6b317a82-7384-4284-9874-7c191e49330d)






