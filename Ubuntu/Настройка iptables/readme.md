```bash
 iptables -t filter -A INPUT -s 10.20.30.40/32 -j DROP

iptables -t filter -A INPUT -s 10.20.30.40/32 -j REJECT

iptables -t filter -A INPUT -s 192.168.0.0/24 -j DROP
iptables -t filter -A INPUT -s 192.168.0.0/255.255.255.0 -j DROP

 iptables -t filter -A INPUT -i enp0s3 -s 8.8.8.8/32 -j DROP
 iptables -t filter -A OUTPUT -o enp0s3 -d 8.8.8.8/32 -j DROP

Как заблокировать подсеть ?
Используйте следующий синтаксис для блокирования 10.0.0.0 /8:
# iptables -I INPUT -s 10.0.0.0/8 -j DROP

Как сохранить заблокированный IP -адрес ?
Чтобы сохранить заблокированный IP -адрес для Iptables в файл конфигурации , введите следующую команду:
service iptables save
или
# /etc/init.d/iptables save

Как разблокировать IP- адрес?
Во-первых, вам нужно отобразить заблокированный IP -адрес вместе с номером строки и прочей информации, для этого введите следующую команду
# iptables -L INPUT -n --line-numbers
# iptables -L INPUT -n --line-numbers | grep 192.168.244.134
Chain INPUT (policy DROP)
num target prot opt source destination
1 DROP all -- 192.168.244.134 0.0.0.0/0
2 LOCALINPUT all -- 0.0.0.0/0 0.0.0.0/0
3 ACCEPT all -- 0.0.0.0/0 0.0.0.0/0
4 ACCEPT udp -- 213.152.14.11 0.0.0.0/0 udp spts:1024:65535 dpt:53

Чтобы разблокировать 192.168.244.134 необходимо удалить номер строки 1, для этого введите:
# iptables -D INPUT 1


Иногда, стоит заблокировать IP следующим образом:
# iptables -A INPUT -s 11.22.33.44 -j REJECT
Где:

-A:  Добавляет правило в таблицу INPUT(входящие пакеты) для IP указанного ИП и выполнет действие REJECT(полностью отбрасывать пакеты не показывая признаков жизни даже по пингу).
— s: Матч IP -адрес источника .
— j : Перейти к указанным целевым цепям , если пакету соответствует текущее правило .


Как заблокировать IP -адрес ?
Пример. Я хочу заблокировать входящий запрос от некоторого IP, предположим 192.168.244.134 , то нужно войти как root и ввести следующую команду:
# iptables -I INPUT -s 192.168.244.134 -j DROP
Где ,
— I: Вставка цепи в верхней части правил .
— s: Матч IP -адрес источника .
— j : Перейти к указанным целевым цепям , если пакету соответствует текущее правило .

Чтобы отбрасывать пакеты , приходящие на интерфейс eth0 с 192.168.244.134 , введите следующую команду:
# iptables -I INPUT -i eth0 -s 192.168.244.134 -j DROP


# iptables -n -L -v 
# iptables -n -L -v --line-numbers
Чтобы можно было отобразить INPUT, OUTPUT цепочки правил нужно выполнить:
# iptables -L INPUT -n -v
# iptables -L OUTPUT -n -v --line-numbers

Чтобы застопать, стартануть или перезапустить файрвол нужно выполнить:
# service ufw stop
# service ufw start
# service iptables stop
# service iptables start
# service iptables restart

Можете заюзать команды iptables чтобы можно было остановить фаервол и удалить все наши правила:
# iptables -F
# iptables -X
# iptables -t nat -F
# iptables -t nat -X
# iptables -t mangle -F
# iptables -t mangle -X
# iptables -P INPUT ACCEPT
# iptables -P OUTPUT ACCEPT
# iptables -P FORWARD ACCEPT

Пояснения ключей:

-F : — Эта опция нужна для удаления (flush) всех правил.
-X : — Этот ключ даст возможность удалять цепь.
-t table_name : — Эта опция нужна для выбора таблицы (nat или mangle) и удалит ваши правила.
-P : Этот ключ выбирает стандартные действия (например DROP, REJECT, или ACCEPT).
5. Если нужно удалить правила в фаерволе следует выполнить:

Если нужно вывести нумерацию строк с уже имеющимися правилами:

# iptables -L INPUT -n --line-numbers
# iptables -L OUTPUT -n --line-numbers
# iptables -L OUTPUT -n --line-numbers | less
# iptables -L OUTPUT -n --line-numbers | grep 198.158.234.134

Пояснение по ключу:
-D : служит для удаления 1 или пары правил из цепи.

6. Если Вы хотите прописать новое правило в фаервол, выполните:

Если необходимо добавить одно или парочку правил в одну цепочку, то для начала выведем список с нумерацией строк:
# iptables -L INPUT -n --line-numbers
пример использования iptables -L INPUT -n --line-numbers
Допустим Вам нужно вставить правило между первой и второй строкой, то нужно выполнить:
# iptables -I INPUT 2 -s 132.178.244.134-j DROP
Убедимся, обновилось ли наше правило:
# iptables -L INPUT -n --line-numbers





Asterisk + IPTables
В этой статье рассматривается простой пример конфигурации iptables для работы с Asterisk

Проверим установлено ли IPTables

[root@localhost ~]# rpm -q iptables
iptables-1.3.5-5.3.el5_4.1
Посмотрим текущие правила используя параметр -L

[root@localhost ~]# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED 
ACCEPT     icmp --  anywhere             anywhere            
ACCEPT     all  --  anywhere             anywhere            
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:ssh 
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited 

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited 

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
Настройка общих правил.
Создадим новые правила

# iptables -P INPUT ACCEPT
Эта команда разрешит все входящие подключения что позволит нам избежать блокировки нашего соединения, если конфигурирование производится через ssh.

# iptables -F
Данная команда сбросит все текущие правила по умолчанию и применит только созданное нами правило.

# iptables -A INPUT -i lo -j ACCEPT
Это простое правило разрешает все подключения на адаптер loopback. Интерфейс loopback определяется системой как lo и по умолчанию имеет адрес 127.0.0.1 Команда -А добавляет новое правило в конец заданной цепочки INPUT. Опция -i вместе именем интерфейса lo разрешает все виды трафика через заданный интерфейс. Опция -j указывает на цель данного правила ACCEPT, принять все подключения.

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
Некоторые части этого правила уже вам знакомы. Далее присутствует опция -m которая используется для загрузки модуля state. Модуль state проверяет состояние пакета и определяет является ли он новым-NEW, уже созданным-ESTABLISHED или новым, но связанным-RELATED с уже установленным соединением. Состояние ESTABLISHED указывает на то, что пакет принадлежит уже установленному соединению через которое пакеты идут в обоих направлениях. Признак NEW подразумевает, что пакет открывает новое соединение или пакет принадлежит однонаправленному потоку. Признак RELATED указывает на то что пакет принадлежит уже существующему соединению, но при этом он открывает новое соединение.

  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
Это правило добавляется к цепочке INPUT и говорит, что все пакеты, приходящие по протоколу TCP (-p tcp), на порт 22 (–dport 22), должны быть приняты(-j ACCEPT). Используется для подключения по ssh c портом по умолчанию.

Если вам требуется открыть доступ к веб серверу цепочка будет выглядеть также, за исключением номера порта.

   
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
Хочу заметить, что php приложения являются очень уязвимым местом часто используемым для взлома Asterisk.;-)

iptables -P INPUT DROP
Помните, первое правило? Когда мы устанавливаем политику по умолчанию для входных цепей принять? Это правило меняет политику по умолчанию для входных цепочек обратно в DROP, что и требуется, если вы хотите на самом деле блокировать трафик поступающий на ваш сервер.

iptables -P FORWARD DROP
Запретим маршрутизацию трафика

iptables -P OUTPUT ACCEPT
Разрешим весь исходящий трафик.

service iptables save
Сохраним созданные правила.

Правила для Asterisk
Рассмотрим правила для SIP, RTP, IAX, AMI

iptables -A INPUT -p udp -m udp --dport 5060 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5061 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 4569 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 5038 -j ACCEPT
Если вы используете TCP:

iptables -A INPUT -p tcp -m tcp --dport 5060 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 5061 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5060 -j ACCEPT – это правило разрешает инициацию SIP подключений к вашему серверу Asterisk от удаленных пользователей или провайдера.

Если у вас нет удаленных пользователей, а например только sip транк от провайдера, хорошая идея разрешить доступ только с определенных ip адресов или сетей.

iptables -A INPUT -p udp -m udp -s 123.123.123.123 --dport 5060 -j ACCEPT
iptables -A INPUT -p udp -m udp -s 192.168.0.0/24 --dport 5060 -j ACCEPT
Первое правило разрешает соединение только с адреса 123.123.123.123, второе только с адреса 125.125.125.125. Третье из сети 192.168.0.XXX для ваших локальных абонентов.

iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT – Данное правило разрешает RTP трафик. Кода иницировано SIP соединение по порту 5060 голосовые потоки направляются на порты из указанного диапазона. Некоторые АТС используют для инициации SIP соединения и для RTP трафика разные интерфейсы. Т.е. если адрес SIP сервера вашего провайдера 123.123.123.123, то RTP трафик, к примеру, может исходить с ip адреса 123.123.123.124 и т.п.
Диапазон rtp портов задается в файле /etc/asterisk/rtp.conf.
iptables -A INPUT -p udp -m udp --dport 4569 -j ACCEPT – Разрешает подключения по протоколу IAX. В отличие от SIP для инициации соединения и для голосовых пакетов RTP используется один и тот же порт.

iptables -A INPUT -p tcp -m tcp --dport 5038 -j ACCEPT – Разрешает подключения к Asterisk Manager Interface.

service iptables save
Сохраним новые правила
в debian и ubuntu добавили пакет iptables-persistent который использует iptables-save/iptables-restore.
Установка:
apt-get install iptables-persistent
Использование:
/etc/init.d/iptables-persistent {start|restart|reload|force-reload|save|flush}
или
/usr/sbin/netfilter-persistent {start|restart|reload|force-reload|save|flush}
Фильтрация по именам сканеров
iptables -I INPUT -p udp --dport 5060 -m string --string "friendly-scanner" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sip-scan" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sundayddr" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "iWar" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipsak" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipvicious" --algo bm -j DROP
Типовой пример настройки iptables для asterisk 

Разрешить ping с определенного источника
Разрешить входящий ICMP трафик с указанного ip или подсети.

iptables -A INPUT -p icmp --icmp-type 8 -s <source_ip> -d <local_ip> -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
Разрешить исходящий ICMP трафик на указанный ip или подсеть.

iptables -A OUTPUT -p icmp --icmp-type 8 -s <local_ip> -d <source_ip> -m state --state ESTABLISHED,RELATED -j ACCEPT
Проброс порта (forward) на другой компьютер в локальной сети
Включим поддержку форвардига для протокола ipv4 в файле /etc/sysctl.conf

 net.ipv4.ip_forward = 1
Применим:

 # sysctl -p /etc/sysctl.conf
Пример для порта 80 TCP:

iptables -A FORWARD -i enp5s2 -o enp4s0 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT &&
iptables -A FORWARD -i enp5s2 -o enp4s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT &&
iptables -A FORWARD -i enp4s0 -o enp5s2 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT &&
iptables -t nat -A PREROUTING -i enp5s2 -p tcp --dport 80 -j DNAT --to-destination 192.168.0.2 &&
iptables -t nat -A POSTROUTING -o enp4s0 -p tcp --dport 80 -d 192.168.0.2 -j SNAT --to-source 192.168.0.1
Проброс с одного порта на другой
Легенда:

external interface - enp5s2
internal interface - enp4s0
internal interface ip - 192.168.0.1
forwarding ip - 192.168.0.2
source ip - 123.123.123.123
external port - 8080
forwarding port - 80
Разрешим форвардинг между интерфейсами:

iptables -A FORWARD -i enp5s2 -o enp4s0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i enp4s0 -o enp5s2 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
Перепишем запрос на порт 8080 внешнего интерфейса,
на адрес и порт компьютера в локальной сети: 192.168.0.2:80.

iptables -t nat -A PREROUTING -i enp5s2 -p tcp -s 123.123.123.123/32 --dport 8080 -j DNAT --to-destination 192.168.0.2:80
Перенаправим запрос c внешнего интерфейса enp5s2 на внутренний интерфейс enp4s0.

iptables -I FORWARD 1 -i enp5s2 -o enp4s0 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT
Отправим запрос с внутреннего интерфейса на адрес 192.168.0.2 порт 80

iptables -t nat -A POSTROUTING -o enp4s0 -p tcp --dport 80 -d 192.168.0.2 -j SNAT --to-source 192.168.0.1
Будет работать только для запросов с адреса 123.123.123.123




```
