1. Подготовка стенда
Раздел частично отсылает к Загрузочный сервер — как загрузочная флешка..., первичная подготовка схожа - для базы используется чистый Debian Bullseye, но думаю, использование другого дистрибутива не будет сильно отличаться.

Дано
VM VirtualBox

Ram: 1 Гб

VDI: 8Gb

CPU: 1 Core

Network: - NAT, подсеть 10.0.2.0, без DHCP, шлюз 10.0.2.1

Astra Linux 1.7.7.9

Необходимо установить:

TFTP

Samba

Apache2

DHCP

1.1. TFTP
Используется для загрузчиков и ipxe скриптов:

apt install tftpd-hpa
Вношу изменения в /etc/default/tftpd-hpa:

TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/srv/tftp" # путь к папке tftp
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure -l -vvv -r blksize -m /etc/tftpd.remap"
Замена слешей Windows на Linux /etc/tftpd.remap:

rg \\ /
