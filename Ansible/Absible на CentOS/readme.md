#### Установка absible на centos 7.

##### Перед установкой сгенерируем ключ ssh-key.

Ключ генерируется с помощью утилиты ssh-keygen, например:

```
-# ssh-keygen -C "$(whoami)@$(hostname)-$(date -I)"
```

Отвечаем везде да (Enter).<br>
Далее копируем ключ на удаленный хост.<br>
```
-# ssh-copy-id -p 2224 username@remote_host  #если порт менялся на ssh.

-# ssh-copy-id username@remote_host #если не менялся и остался по умолчанию 22
```

Можно создать папку authorized_keys и туда поместить ключ.

```
-# cat ~/.ssh/id_rsa.pub | ssh username@remote_host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

Чтобы проверить, действительно ли скопировался открытый ключ, точно так же, как в первом варианте, найдем искомый файл authorized_keys на удаленном узле и посмотрим его содержимое.

```
~# cat /root/.ssh/id_rsa
```
