##### Запускать скрипты sh из командной строки.

Переходи в папку со скриптами
```python
user@ub3-12:cd /home/user/public/Scripts
user@ub3-12:~/public/Scripts$
```
1. Сделать файл скрипта исполняемым (если он еще таковым не является):
```python
chmod +x script.sh
```
2. Если вы находитель не корневой папке со скриптами, тогда запускаем скрипт, просто указав путь до него:
```python
sudo sh /home/user/public/Scripts/comment.sh
или так
sudo bash /home/user/public/Scripts/comment.sh
или так
sudo sh 192.168.19.33/home/user/public/Scripts/comment.sh
```
3. Если в корневой папке со скриптами, тогда запускаем скрипт командой
```python
sudo ./comment.sh  
или
sudo ./'comment (name_str).sh'
или
sudo sh ./comment.sh 
```
> Пример

Закомментируем строку в файле fstab вот эту например ``UUID=65FA-E861  /boot/efi       vfat    umask=0077      0       1``

![image](https://github.com/user-attachments/assets/2ab611aa-afae-4b2c-b360-139c245a17c3)
```python
sudo sh ./comment.sh               - команда комментирует строку по номеру строки 
sudo sh ./'comment (name_str).sh'  - команда комментирует строку по имени 
```
Создадим и выполним скрипт comment.sh 
```python
sudo touch comment.sh
sudo cat > comment.sh
#!/bin/bash
sudo sed -i '13s/^/#/' /etc/fstab - закомментируем 13 строку

sudo chmod +x comment.sh
sudo sh ./comment.sh
```
![image](https://github.com/user-attachments/assets/3f2f9da2-9ba5-4893-bd45-2946b5886b63)

Смотрим результат
```python
nano /etc/fstab
#UUID=65FA-E861  /boot/efi       vfat    umask=0077      0       1
```
![image](https://github.com/user-attachments/assets/8dadf669-843d-48e6-b8dc-0c257a625f84)


!!!!!!!!!!!

Перед выполнением не забудьте дать разрешение на выполнение скрипта если вы их скопировали в другое место.

- chmod +x comment.sh
- chmod +x uncomment.sh
- chmod +x 'comment (name_str).sh'
- chmod +x 'uncomment (name_str).sh' 

!!!!!!!!!!!

