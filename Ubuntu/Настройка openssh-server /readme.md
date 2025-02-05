#### Устанавливаем SSH 
```bash
Проверим установлен ли openssh-server 
ssh localhost
Устанавливаем
sudo apt install -y openssh-server
Перезагружаем службу
sudo systemctl restart sshd
или
sudo systemctl restart sshd.service

Проверим службу
sudo systemctl status ssh

● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-12-13 19:53:23 MSK; 3min 21s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 2866 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 2867 (sshd)
      Tasks: 1 (limit: 4575)
     Memory: 3.6M
     CGroup: /system.slice/ssh.service
	 
Редактируем файл конфига, меняем порт
nano /etc/ssh/sshd_config

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

Port 2269
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
	 
Сохраняем и перезагружаем службу
sudo systemctl restart sshd

Проверяем доступ через powershell
ssh -p2269 sol@192.168.1.39  или так ssh sol@192.168.1.39 -p2269
-yes
sol@ub01:~$

Добавим в файервол
sudo ufw status (active/inactive)
sudo ufw allow from any to any port 2222 proto tcp
```
