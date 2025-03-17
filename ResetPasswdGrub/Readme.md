#### Сброс пароля на Linux через Grub
Сброс пароля на Linux может потребоваться, если пароль был утерян или раскрыт.

Чтобы открыть меню ``Grub``, при загрузке компьютера нажмите ``Shift`` или ``Esc``. Мне на VMWare Workstation  помогла клавиша ``ESC``.

![1](https://github.com/user-attachments/assets/d6659baf-49f6-4a09-8169-b28a3bb44970)

Выберите опцию «Режим восстановления» для вашего Linux-дистрибутива и нажмите ``Enter``.Это позволит войти в режим восстановления и обслуживания системы.

![2](https://github.com/user-attachments/assets/e3d6f9db-9557-4a68-9158-11a9c6aec271)

Выберите опцию в меню ``root`` вы попадёте в командную строку.

![4](https://github.com/user-attachments/assets/d9bb1524-ae67-4939-81ea-6b1f82ac3ada)

Чтобы смонтировать корневую файловую систему в режиме чтения/записи, введите команду:
```python
mount -o remount,rw /
```
Эта команда позволит внести изменения в корневую файловую систему.
Измените пароль с помощью команды:
```python
passwd   sol
```
После всей манипуляций перезагрузка
```python
reboot
```
![5](https://github.com/user-attachments/assets/2af59f28-a0c2-4088-b9ad-1b48c77a0c5c)

И вход в систему с еовым паролем

![6](https://github.com/user-attachments/assets/16f5bb26-aaaa-4047-997a-2661fa7f12f3)
