### Как установить систему мониторинга Grafana на VPS, работающий под управлением Ubuntu 24.04.


sudo apt update
curl https://packagecloud.io/gpg.key | sudo apt-key add -

wget https://dl.grafana.com/oss/release/grafana_11.5.2_amd64.deb
sudo dpkg -i grafana_11.5.2_amd64.deb
sudo apt-cache policy grafana
sudo apt install grafana
запустите сервис и добавьте его в автозагрузку
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
проверьте статус
sudo systemctl status grafana-server
Чтобы установить соединение, создайте правило для порта 3000 для брандмауэра:
sudo ufw allow 3000/tcp
Войдите в интерфейс. Для этого введите в адресной строке браузера: http://localhost:3000
Откроется стартовая страница. Введите логин и пароль по умолчанию (admin — admin) и нажмите Log in:
