##### Установка
```bash
apt install samba samba-common

Для тестирования настроек устанавливаем клиент Samba.

apt install smbclient

apt install samba-common-bin

Настройки
Скопируем шаблонный файл настроек на случай возврата в исходное состояние.

cp /etc/samba/smb.conf /etc/samba/smb.conf.backup

Удаляем все закомментированные строки из файла настроек.

bash -c 'grep -v -E "^#|^;" /etc/samba/smb.conf.backup | grep . > /etc/samba/smb.conf'

Создаем отдельного системного пользователя

useradd -m -c "Name_User" -s /bin/bash usersamba

Установка пароля:

passwd usersamba

smbpasswd -a usersamba

Создаем общую папку Samba, доступную для всех
Создание папки:

mkdir -p /home/usersamba/smb/

Настраиваем права доступа к папке:

chown -R nobody:nogroup /home/usersamba/smb/

chmod ug+rwx /home/usersamba/smb/

или

chmod -R 0775 /home/usersamba/smb/

Для доменной сети:

chown root:"пользователи домена" /home/usersamba/smb/

Редактируем настройки
sudo gedit /etc/samba/smb.conf

Добавляем в конец файла /etc/samba/smb.conf следующие строки: 
usersamba заменяем на имя пользователя компьютера с Samba.

Папка будет открыта для чтения и записи.

[public]
comment = Samba Share
path = /home/usersamba/smb/
guest ok = yes
browsable =yes
writable = yes
read only = no
force user = usersamba
force group = usersamba

Перезапуск Samba
systemctl restart smbd.service

service smbd restart

Проверка правильности конфигурации Samba
testparm
```

