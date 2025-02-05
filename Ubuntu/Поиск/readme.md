Если у вас есть много файлов и вы не можете их руками переместить, то воспользуйтесь командой:
```bash
find /opt/mydir/logs/ -mindepth 1 -newermt '2018-03-12 00:00:00' ! -newermt '2018-03-14 23:59:59' | xargs -I list mv list /backup/mybackupdir/2018_03/
```

Можно сделать без пайпов в одну команду используя ключ -exec
Что-то типа:
```bash
find /opt/mydir/logs/ -mindepth 1 -newermt '2018-03-12 00:00:00' ! -newermt '2018-03-14 23:59:59' -exec mv {} /backup/mybackupdir/2018_03/
```
