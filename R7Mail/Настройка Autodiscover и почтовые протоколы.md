### Настройка Autodiscover для корпоративного почтового сервера Р7

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
---

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
