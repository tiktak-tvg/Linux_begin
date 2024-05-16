#### Руководство по установке гостевой операционной системы.
Поддерживаемые гостевые операционные системы.<br>
VMware поддерживает следующие операционные системы Windows, Linux, Unix, Macintosh и другие.<br> 
Операционные системы, не указанные в списке, не поддерживаются.<br>
Чтобы узнать, какие настройки гостевой операционной системы<br>
поддерживаются для конкретной версии vSphere или vCenter, <br>
см. матрицу поддержки настроек гостевой ОС.<br>

``https://partnerweb.vmware.com/GOSIG/home.html``

> Пример установки open-vm-tools на OS Debian.

Добавим репозиторий deb http://ftp.debian.org/debian/ bookworm main contrib в файл /etc/apt/sources.list.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/d7b1afa3-9ea0-45fa-829b-5898052bb143)

> И выполним команды.

```
$ sudo apt-get update
$ sudo apt-get install open-vm-tools
```
После установки, можно закомментировать строку.

![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/ed69c3ec-a597-4ec0-8815-60e6db3ca825)

В итоге появится строка с IP адресом и ``VMTools running``.


![image](https://github.com/tvgVita69/Linux_begin/assets/98489171/51121954-f585-4d83-a07a-46bcf2f43f66)
