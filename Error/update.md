#### Встречающиеся ошибки при работе с линукс.

При выполнении обоновления ``apt update`` сообщение об ошибке:

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/e81d6e41-32f2-4da5-9cb6-a9d7c0d0cba3)

> Решение.

```
 apt-key adv --fetch-keys 'https://packages.sury.org/php/apt.gpg' > /dev/null 2>&1
```

Как посмотреть какие пакеты можно обновить и до какой версии.

```
apt list --upgradable
```

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/1f9116bf-b210-4139-8589-6052a6c39ed1)

