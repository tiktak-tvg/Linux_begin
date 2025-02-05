```bash
# from https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-centos-7
sudo yum install epel-release
sudo yum update

sudo yum install nginx

# start nginx
sudo systemctl start nginx

# If you are running a firewall, run the following commands to allow HTTP and HTTPS traffic:

sudo firewall-cmd --permanent --zone=public --add-service=http 
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

# verify
curl http://localhost

# to find the public IP of the server
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```
