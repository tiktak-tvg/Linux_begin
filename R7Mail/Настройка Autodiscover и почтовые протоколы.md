### Настройка Autodiscover для корпоративного почтового сервера Р7

![image](https://github.com/user-attachments/assets/4a62988c-49fe-42b5-a39e-3c9a7f58c507)

Для настройки Autodiscover в Р7-Офис или Почта Р7 выполните следующие шаги:

---

#### 1. Подготовка DNS-записей
Добавьте в DNS вашего домена:# Основная запись
```bash
           autodiscover.IN.CNAME mail.ваша-компания.ru.
```
##### Альтернативно (если не поддерживается CNAME)
```bash
autodiscover.IN.A 192.0.2.1
```

##### SRV-запись для улучшения совместимости
```bash
           _autodiscover._tcp.IN.SRV 10 0 443 mail.ваша-компания.ru.
```
---

#### 2. Создание XML-файла Autodiscover
Создайте файл /var/www/autodiscover/autodiscover.xml с содержимым:
```bash
<?xml version="1.0" encoding="UTF-8"?>
<Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006">
  <Response>
    <Account>
      <AccountType>email</AccountType>
      <Protocol>
        <Type>IMAP</Type>
        <Server>mail.ваша-компания.ru</Server>
        <Port>993</Port>
        <LoginName>%EMAILADDRESS%</LoginName>
        <SSL>on</SSL>
        <AuthRequired>on</AuthRequired>
      </Protocol>
      <Protocol>
        <Type>SMTP</Type>
        <Server>mail.ваша-компания.ru</Server>
        <Port>587</Port>
        <SSL>starttls</SSL>
        <AuthRequired>on</AuthRequired>
      </Protocol>
    </Account>
  </Response>
</Autodiscover>
```

erver {
    listen 443 ssl;
    server_name autodiscover.it.vit.lan;

    # SSL-сертификат (должен включать autodiscover.ваша-компания.ru)
    ssl_certificate /etc/ssl/certs/it.vit.lan.crt;
    ssl_certificate_key /etc/ssl/private/it.vit.lan.key;

    # Основной endpoint
    location = /autodiscover/autodiscover.xml {
        alias /var/www/autodiscover/autodiscover.xml;
        default_type application/xml;
    }

    # Для совместимости с Outlook
    location = /Autodiscover/Autodiscover.xml {
        alias /var/www/autodiscover/autodiscover.xml;
        default_type application/xml;
    }

    # Thunderbird autoconfig
    location = /.well-known/autoconfig/mail/config-v1.1.xml {
        alias /var/www/autodiscover/thunderbird.xml;
        default_type application/xml;
    }
}

```
---
```bash
#### 3. Настройка веб-сервера (Nginx)
Добавьте конфигурацию в /etc/nginx/conf.d/autodiscover.conf:
```bash
server {
    listen 443 ssl;
    server_name autodiscover.ваша-компания.ru;

    # SSL-сертификат (должен включать autodiscover.ваша-компания.ru)
    ssl_certificate /etc/ssl/certs/your_domain.crt;
    ssl_certificate_key /etc/ssl/private/your_domain.key;

    # Основной endpoint
    location = /autodiscover/autodiscover.xml {
        alias /var/www/autodiscover/autodiscover.xml;
        default_type application/xml;
    }

    # Для совместимости с Outlook
    location = /Autodiscover/Autodiscover.xml {
        alias /var/www/autodiscover/autodiscover.xml;
        default_type application/xml;
    }

    # Thunderbird autoconfig
    location = /.well-known/autoconfig/mail/config-v1.1.xml {
        alias /var/www/autodiscover/thunderbird.xml;
        default_type application/xml;
    }
}
```
Перезагрузите Nginx: 
```bash
              sudo nginx -t && sudo systemctl reload nginx
```
---

#### 4. Дополнительно: Файл для Thunderbird
Создайте /var/www/autodiscover/thunderbird.xml:<?xml version="1.0"?>
```bash
<clientConfig version="1.1">
  <emailProvider id="ваша-компания.ru">
    <domain>ваша-компания.ru</domain>
    <displayName>Почта Вашей Компании</displayName>
    <incomingServer type="imap">
      <hostname>mail.ваша-компания.ru</hostname>
      <port>993</port>
      <socketType>SSL</socketType>
      <authentication>password-encrypted</authentication>
    </incomingServer>
    <outgoingServer type="smtp">
      <hostname>mail.ваша-компания.ru</hostname>
      <port>587</port>
      <socketType>STARTTLS</socketType>
      <authentication>password-encrypted</authentication>
    </outgoingServer>
  </emailProvider>
</clientConfig>
```
---

#### 5. Настройка в панели Р7 (если доступно)
1. Войдите в админ-панель https://mail.ваша-компания.ru/admin
2. Перейдите: Почта → Настройки автообнаружения
3. Укажите:
   - URL Autodiscover: https://autodiscover.ваша-компания.ru/autodiscover/autodiscover.xml
   - Домены: ваша-компания.ru
4. Сохраните изменения

---

#### 6. Проверка работы
1. Тест в браузере:  
   Откройте https://autodiscover.ваша-компания.ru/autodiscover/autodiscover.xml → Должен отобразиться XML.

2. Тест через Outlook:
   ```bash
     Test-EmailAutoConfiguration -Identity user@ваша-компания.ru -Protocol Autodiscover
   ```
4. Онлайн-валидация:  
   Используйте [Microsoft Connectivity Analyzer](https://testconnectivity.microsoft.com).

---

#### 7. Решение проблем
| Ошибка | Решение |
|-------|---------|
| 404 Not Found | Проверьте пути в Nginx и права доступа к файлам (`chmod 644`) |
| SSL-ошибки | Убедитесь, что сертификат включает autodiscover.ваша-компания.ru |
| Outlook не подхватывает настройки | Добавьте SRV-запись в DNS |
| Не применяются настройки из панели Р7 | Проверьте синтаксис XML-файла через [XML Validator](https://www.




Для настройки **Autodiscover** на корпоративном почтовом сервере **Р7** (российское решение, например, **Почта Р7** или **Р7-Офис**) выполните следующие шаги. Учтите, что Р7 часто базируется на **Alt Linux**/**Astra Linux** и использует **Postfix/Dovecot** или аналоги.

---

### 1. **Требования**
- **Домен**: `ваша-компания.ru`
- **SSL-сертификат**:  
  Должен покрывать:  
  - `autodiscover.ваша-компания.ru`  
  - `mail.ваша-компания.ru`
- **Доступ к**:  
  - Веб-серверу (Nginx/Apache)  
  - DNS-панели  
  - Панели управления Р7 (если есть).

---

### 2. **Настройка DNS**
Добавьте записи:

| Тип      | Имя                         | Значение                     | TTL  |
|----------|-----------------------------|------------------------------|------|
| `CNAME`  | `autodiscover`              | `mail.ваша-компания.ru`      | 3600 |
| `A`      | `mail`                      | `<IP вашего сервера>`        | 3600 |
| `SRV`    | `_autodiscover._tcp`        | `10 0 443 mail.ваша-компания.ru` | 3600 |

---

### 3. **Создание Autodiscover-файла**
Autodiscover в Р7 реализуется через **XML/JSON-файл** на веб-сервере.  
Создайте файл:  
`/var/www/autodiscover/autodiscover.xml` (путь может отличаться).

#### Пример для **IMAP/SMTP**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006">
  <Response>
    <Account>
      <AccountType>email</AccountType>
      <Protocol>
        <Type>IMAP</Type>
        <Server>mail.ваша-компания.ru</Server>
        <Port>993</Port>
        <LoginName>%EMAILADDRESS%</LoginName>
        <SSL>on</SSL>
      </Protocol>
      <Protocol>
        <Type>SMTP</Type>
        <Server>mail.ваша-компания.ru</Server>
        <Port>587</Port>
        <SSL>starttls</SSL>
      </Protocol>
    </Account>
  </Response>
</Autodiscover>
```

> Замените `%EMAILADDRESS%` на переменную вашей системы (если поддерживается).

---

### 4. **Настройка веб-сервера**
#### Для Nginx:
```nginx
server {
    listen 443 ssl;
    server_name autodiscover.ваша-компания.ru;

    ssl_certificate /etc/ssl/certs/ваш_сертификат.crt;
    ssl_certificate_key /etc/ssl/private/ваш_ключ.key;

    location /autodiscover/autodiscover.xml {
        alias /var/www/autodiscover/autodiscover.xml;
        default_type application/xml;
    }

    # Для поддержки Outlook 
    location /Autodiscover/Autodiscover.xml {
        alias /var/www/autodiscover/autodiscover.xml;
        default_type application/xml;
    }
}
```
> После настройки выполните:  
> ```bash
> sudo nginx -t && sudo systemctl reload nginx
> ```

---

### 5. **Интеграция с клиентами**
#### Thunderbird / Outlook:
- Пользователь вводит **email и пароль** → клиент автоматически запрашивает:  
  `https://autodiscover.ваша-компания.ru/autodiscover/autodiscover.xml`.

#### Мобильные устройства (Android/iOS):
- Используют тот же URL. Убедитесь, что сертификат SSL доверенный.

---

### 6. **Проверка работы**
1. **Ручной тест в браузере**:  
   Откройте:  
   `https://autodiscover.ваша-компания.ru/autodiscover/autodiscover.xml`  
   → Должен отобразиться XML.

2. **Тест через telnet/openssl**:
   ```bash
   openssl s_client -connect autodiscover.ваша-компания.ru:443
   GET /autodiscover/autodiscover.xml HTTP/1.1
   Host: autodiscover.ваша-компания.ru
   ```
   → Убедитесь, что возвращается XML.

3. **Тест в Outlook**:  
   Используйте [Microsoft Remote Connectivity Analyzer](https://testconnectivity.microsoft.com) → раздел **Autodiscover**.

---

### 7. **Расширенные настройки для Р7**
- **Поддержка ActiveSync** (если есть):  
  Добавьте в XML блок:
  ```xml
  <Protocol>
    <Type>ActiveSync</Type>
    <Server>mail.ваша-компания.ru</Server>
    <Port>443</Port>
    <SSL>on</SSL>
  </Protocol>
  ```

- **Интеграция с LDAP/AD**:  
  Если Р7 использует каталог пользователей, укажите в настройках клиента:  
  ```xml
  <LoginName>%USERNAME%@ваша-компания.ru</LoginName>
  ```

---

### 8. **Типичные проблемы**
| Проблема                          | Решение                                                                 |
|-----------------------------------|-------------------------------------------------------------------------|
| Ошибка 404                        | Проверьте путь к XML и права доступа (`chmod 644`).                     |
| Сертификат не доверенный          | Используйте сертификат от Let's Encrypt или коммерческого ЦС.           |
| Клиент игнорирует Autodiscover    | Убедитесь, что в DNS есть CNAME и SRV-запись.                           |
| Блокировка фаерволом              | Откройте порт 443 для `autodiscover.ваша-компания.ru`.                 |
| Неверный Content-Type             | Укажите в веб-сервере: `application/xml`.                               |

---

### 9. **Альтернатива: Autoconfig**
Для совместимости с Thunderbird создайте дополнительно файл:  
`https://mail.ваша-компания.ru/.well-known/autoconfig/mail/config-v1.1.xml`

Пример:
```xml
<?xml version="1.0"?>
<clientConfig version="1.1">
  <emailProvider id="ваша-компания.ru">
    <domain>ваша-компания.ru</domain>
    <incomingServer type="imap">
      <hostname>mail.ваша-компания.ru</hostname>
      <port>993</port>
      <socketType>SSL</socketType>
      <authentication>password-cleartext</authentication>
    </incomingServer>
    <outgoingServer type="smtp">
      <hostname>mail.ваша-компания.ru</hostname>
      <port>587</port>
      <socketType>STARTTLS</socketType>
      <authentication>password-cleartext</authentication>
    </outgoingServer>
  </emailProvider>
</clientConfig>
```

---

### Важно!
1. Для **корпоративной безопасности** ограничьте доступ к Autodiscover по IP или используйте HTTP-аутентификацию.
2. В **Р7-Офис** Autodiscover может настраиваться через административную панель — проверьте раздел **«Почта» → «Автонастройка клиентов»**.
3. Для MDM-систем (Mobile Device Management) используйте **AppConfig**-параметры.

Документация:  
- [Официальный мануал Р7-Офис](https://docs.r7-office.ru/) (раздел «Почтовый сервер»).  
- [Autodiscover для кастомных решений](https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Autoconfiguration).


Для настройки SRV-записи IMAP в DNS необходимо создать запись, указывающую на сервер, предоставляющий IMAP-сервис через TCP. Вот ключевые параметры и примеры:

### Формат SRV-записи:
```plaintext
_Service._Proto.Name TTL Class SRV Priority Weight Port Target
```
- **Service**: `_imap` (обычный IMAP) или `_imaps` (IMAP через SSL/TLS)  
- **Proto**: `_tcp`  
- **Name**: Доменное имя (например, `example.com`)  
- **Priority**: Приоритет сервера (ниже = выше приоритет)  
- **Weight**: Распределение нагрузки (если несколько серверов с одинаковым приоритетом)  
- **Port**: Порт сервера  
- **Target**: FQDN сервера (например, `mail.example.com`)  

---

### Примеры записей:
1. **IMAP (порт 143)**:  
   ```dns
   _imap._tcp.example.com. 3600 IN SRV 10 5 143 mail.example.com.
   ```
   - Приоритет: `10`, Вес: `5`, Порт: `143`.

2. **IMAPS (порт 993)**:  
   ```dns
   _imaps._tcp.example.com. 3600 IN SRV 10 5 993 mail.example.com.
   ```
   - Используется для защищённого подключения (SSL/TLS).

---

### Как проверить:
Используйте команду `dig`:
```bash
dig +short SRV _imap._tcp.example.com
```
Вывод должен отобразить созданную запись.

---

### Важные замечания:
1. **Поддержка клиентов**:  
   SRV-записи для IMAP поддерживаются не всеми клиентами (например, Thunderbird и Outlook используют MX-записи). Убедитесь, что ваш клиент/сервер требует SRV (например, Autodiscover для Exchange).
2. **Порты**:  
   - `143`: Стандартный порт IMAP (без шифрования).  
   - `993`: Порт IMAPS (шифрование SSL/TLS).  
3. **TTL**:  
   Указывает срок кэширования записи (в секундах). `3600` = 1 час.

---

### Когда использовать SRV для IMAP?
- Если сервер использует **нестандартные порты** (например, IMAP на порту 2143).  
- Для балансировки нагрузки между несколькими серверами.  
- В специализированных системах (например, Autodiscover Microsoft Exchange).  

Для стандартных IMAP-развёртываний чаще используются MX-записи и A/AAAA-записи.
