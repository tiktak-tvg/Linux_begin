### Настройка Autodiscover для корпоративного почтового сервера Р7

Для настройки Autodiscover в **Корпоративном почтовом сервере Р7** выполните следующие шаги:

#### 1.Подготовка DNS-записей
Добавьте в DNS вашего домена:
```bash
# Основная запись
autodiscover.IN.CNAME r7mx1.it.company.lan

# Альтернативно (если не поддерживается CNAME)
autodiscover.IN.A 192.168.25.91

# SRV-запись для улучшения совместимости
_autodiscover._tcp.IN.SRV 10 0 443 r7mx1.it.company.lan
```
Пример с ALD PRO:

| Тип      | Имя                         | Значение                     | TTL  |
|----------|-----------------------------|------------------------------|------|
| `CNAME или A`  | `autodiscover`        | `r7mx1(имя почтового сервера)`| 3600 |
| `A`      | `r7mx1`                      | `192.168.25.91`        | 3600 |
| `SRV`    | `_autodiscover._tcp`        | `10 0 443 r7mx1` | 3600 |

---

#### 2.Создание XML-файла Autodiscover
Создайте папку `mkdir /var/www/autodiscover`

Создайте файл `touch /var/www/autodiscover/autodiscover.xml` 

Создайте файл `nano /var/www/autodiscover/autodiscover.xml` заполните содержимым:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006">
  <Response>
    <Account>
      <AccountType>email</AccountType>
      <Protocol>
        <Type>IMAP</Type>
        <Server>r7mx1.it.company.lan</Server>
        <Port>993</Port>
        <LoginName>%EMAILADDRESS%</LoginName>
        <SSL>on</SSL>
        <AuthRequired>on</AuthRequired>
      </Protocol>
      <Protocol>
        <Type>SMTP</Type>
        <Server>r7mx1.it.company.lan</Server>
        <Port>587</Port>
        <SSL>starttls</SSL>
        <AuthRequired>on</AuthRequired>
      </Protocol>
    </Account>
  </Response>
</Autodiscover>
```
---

#### 3.Настройка веб-сервера (Nginx)
Добавьте конфигурацию в файл `nano /etc/nginx/conf.d/autodiscover.conf`:

```nginx
server {
    listen 443 ssl;
    server_name autodiscover.it.company.lan;

    # SSL-сертификат (должен включать autodiscover.ваша-компания.ru)
    ssl_certificate /etc/nginx/ssl/it.company.lan.crt;
    ssl_certificate_key /etc/nginx/ssl/it.company.lan.key;

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
проверить запись на ошибки
nginx -t

systemctl reload nginx
```
---

#### 4.Дополнительно: Файл для Thunderbird
Создайте файл `nano /var/www/autodiscover/thunderbird.xml`:
```xml
<?xml version="1.0"?>
<clientConfig version="1.1">
  <emailProvider id="it.company.lan">
    <domain>it.company.lan</domain>
    <displayName>Почта Вашей Компании</displayName>
    <incomingServer type="imap">
      <hostname>r7mx1.it.company.lan</hostname>
      <port>993</port>
      <socketType>SSL</socketType>
      <authentication>password-encrypted</authentication>
    </incomingServer>
    <outgoingServer type="smtp">
      <hostname>r7mx1.it.company.lan</hostname>
      <port>587</port>
      <socketType>STARTTLS</socketType>
      <authentication>password-encrypted</authentication>
    </outgoingServer>
  </emailProvider>
</clientConfig>
```
---

#### 5.Проверка работы
1. **Тест в браузере**:  
   Откройте `https://autodiscover.it.company.lan/autodiscover/autodiscover.xml` → Должен отобразиться XML.

2. **Тест через Outlook**:
   ```powershell
   Test-EmailAutoConfiguration -Identity info@it.company.lan -Protocol Autodiscover
   ```
---

#### 6.Решение проблем
| Ошибка | Решение |
|-------|---------|
| *404 Not Found* | Проверьте пути в Nginx и права доступа к файлам (`chmod 644`) |
| *SSL-ошибки* | Убедитесь, что сертификат включает `autodiscover.it.company.lan` |
| *Outlook не подхватывает настройки* | Добавьте SRV-запись в DNS |

---

#### 7.Оптимизация для Р7
1. **Интеграция с LDAP/AD**:  
   В файле `autodiscover.xml` укажите:
   ```xml
   <LoginName>%USERNAME%@it.company.lan</LoginName>
   ```

2. **Поддержка ActiveSync**:  
   Добавьте в XML:
   ```xml
   <Protocol>
     <Type>ActiveSync</Type>
     <Server>r7mx1.it.company.lan</Server>
     <Port>443</Port>
     <SSL>on</SSL>
   </Protocol>
   ```

3. **Безопасность**:  
   Ограничьте доступ по IP в Nginx:
   ```nginx
   allow 192.168.1.0/24;
   allow 203.0.113.5;
   deny all;
   ```

---

### Важные особенности Р7:
1. **Стандартные порты**:
   - IMAPS: 993
   - SMTPS: 465
   - Submission: 587

2. **Аутентификация**:  
   Для Outlook требуется:
   ```xml
   <AuthRequired>on</AuthRequired>
   ```

3. **Поддержка переменных**:  
   Р7 понимает:
   - `%EMAILADDRESS%` → user@domain.ru
   - `%USERNAME%` → логин без домена


