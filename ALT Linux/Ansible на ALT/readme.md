Устанавливаем ansible:
```bash
apt-get install ansible
```
2. Прописываем управляемые компьютеры в группу (local). В файл /etc/ansible/hosts требуется добавить (а в новых версиях Ansible желательно указать пользователя, под которым будет запущены команды на управляемых узлах (root)):
```bash
[all:vars]
ansible_user=root

[local]
10.10.3.77
```
3. Так как управление будет осуществляться через ssh по ключам, создаём ключ SSH:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/manager
```
Пароль ключа можно оставить пустым.

4. Добавить ключ на сервере:
```bash
eval `ssh-agent`
ssh-add ~/.ssh/manager
```
5. Создадим каталог для пакетов рецептов (playbooks):
```bash
mkdir -p /etc/ansible/playbooks
```
Подготовка клиента
1. Устанавливаем необходимые модули:
```bash
apt-get install python python-module-yaml python-module-jinja2 python-modules-json python-modules-distutils
```
2. Включаем и запускаем службу sshd:

для SystemV:
```bash
chkconfig sshd on
service sshd start
```
для SystemD:
```bash
systemctl enable sshd.service
systemctl start sshd.service
```
3. Размещаем публичную часть созданного на сервере ключа пользователю root (в модуле Администратор или вручную добавить содержимое файла ``manager.pub`` в ``/etc/openssh/authorized_keys/root``.

4. Проверим доступ по ключу с сервера:
```bash
ssh root@10.10.3.77
```
Проверка доступности
Используем модуль «ping»:
```bash
# ansible -m ping local
10.10.3.77 | SUCCESS => {
    "changed": false, 
    "failed": false, 
    "ping": "pong"
}
```
