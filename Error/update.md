#### Встречающиеся ошибки при работе с линукс.

При выполнении обоновления ``apt update`` сообщение об ошибке:

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ff2ece09-6c39-4d72-b7bb-c2344bedaaef)

> Решение.

```
 apt-key adv --fetch-keys 'https://packages.sury.org/php/apt.gpg' > /dev/null 2>&1
```

Как посмотреть какие пакеты можно обновить и до какой версии.

```
apt list --upgradable
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/1f9116bf-b210-4139-8589-6052a6c39ed1)

