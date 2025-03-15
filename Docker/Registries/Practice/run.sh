#!/bin/bash

docker network create school

docker run --restart always -d -p 80:80 -p 443:443 --name proxy --net school nginx

docker run --restart always -d --name registry --net school registry:2

# Optional
# apt-get update && apt-get install iputils-ping vim curl -y

# https://www.digitalocean.com/community/tutorials/how-to-use-certbot-standalone-mode-to-retrieve-let-s-encrypt-ssl-certificates-on-ubuntu-16-04
sudo docker container cp /etc/letsencrypt/archive/sotream.xyz/fullchain1.pem proxy:/etc/ssl/certs/fullchain.pem
sudo docker container cp /etc/letsencrypt/archive/sotream.xyz/privkey1.pem proxy:/etc/ssl/certs/privkey.pem
sudo docker container cp /etc/letsencrypt/archive/sotream.xyz/chain1.pem proxy:/etc/ssl/certs/chain.pem

docker cp nginx.conf proxy:/etc/nginx/nginx.conf

docker restart proxy