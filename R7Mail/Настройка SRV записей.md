![image](https://github.com/user-attachments/assets/12fb8057-eb57-4fa8-9532-3023e0b9911b)


Настройка SRV-записей для почтового сервера помогает клиентам автоматически находить сервисы (SMTP, IMAP и т.д.) через DNS. Вот пошаговая инструкция:

### 1. **Основные параметры SRV-записи**
Формат записи:  
`_Сервис._Протокол.Домен. TTL Класс SRV Приоритет Вес Порт Цель`

Пример:  
`_submission._tcp.example.com. 3600 IN SRV 10 5 587 mail.example.com.`

### 2. **Ключевые сервисы для почты**
- **SMTP (отправка):**
  - `_submission._tcp` (порт 587) — для клиентской отправки
  - `_smtps._tcp` (порт 465) — SMTP over SSL
- **IMAP (получение):**
  - `_imap._tcp` (порт 143)
  - `_imaps._tcp` (порт 993) — IMAP over SSL
- **POP3 (получение):**
  - `_pop3._tcp` (порт 110)
  - `_pop3s._tcp` (порт 995) — POP3 over SSL
- **Autodiscover (автонастройка):**
  - `_autodiscover._tcp` (порт 443)

### 3. **Примеры записей**
```dns
; Отправка почты (клиенты)
_submission._tcp.example.com.  3600 IN SRV 10 5 587 mail.example.com.

; Получение почты (IMAP)
_imaps._tcp.example.com.       3600 IN SRV 10 0 993 mail.example.com.

; Autodiscover (для Outlook/Thunderbird)
_autodiscover._tcp.example.com. 3600 IN SRV 10 0 443 mail.example.com.
```

### 4. **Параметры**
- **Приоритет (Priority):** Меньше значение → выше приоритет.  
- **Вес (Weight):** Балансировка нагрузки между серверами одного приоритета.  
- **Порт (Port):** TCP-порт сервиса (587, 993 и т.д.).  
- **Цель (Target):** FQDN почтового сервера (должен иметь A/AAAA-запись).  

### 5. **Как добавить запись**
1. Зайдите в панель управления DNS-хостингом (Cloudflare, REG.RU и т.д.).  
2. Создайте новую запись типа **SRV**.  
3. Заполните поля по шаблону:  
   - **Service:** `_submission._tcp` (или другой сервис)  
   - **Target:** `mail.example.com` (ваш сервер)  
   - **Priority:** `10`  
   - **Weight:** `5`  
   - **Port:** `587`  

### 6. **Проверка**
Используйте команды:  
```bash
dig SRV _submission._tcp.example.com
# или
nslookup -type=SRV _submission._tcp.example.com
```

### Важные нюансы
1. **Поддержка клиентов:**  
   SRV-записи работают не со всеми клиентами (Outlook поддерживает для Autodiscover, Thunderbird — для IMAP/SMTP).  
2. **Обязательные A/AAAA-записи:**  
   Убедитесь, что `mail.example.com` разрешается в IP-адрес.  
3. **Autodiscover:**  
   Для Exchange/Office 365 используйте `_autodiscover._tcp` + HTTPS-ресурс `https://autodiscover.example.com/autodiscover/autodiscover.xml`.  
4. **Безопасность:**  
   Для портов 465/587/993 используйте SSL/TLS.  

### Альтернативы
- **MX-записи:** Для входящей почты (не для SRV).  
- **Явные настройки:** Если SRV не поддерживается, укажите сервер вручную в клиенте.  

Настройка SRV упрощает автоматическую конфигурацию почтовых программ, но проверяйте поддержку вашими клиентами.

![image](https://github.com/user-attachments/assets/3d6c0ae4-5442-434c-a7fd-8c3afbc9fc0b)

![image](https://github.com/user-attachments/assets/445bb0a3-0eea-4386-9f37-f614a46ebe55)

