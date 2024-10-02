#!/bin/bash

echo "Instance Startup script is started" > /var/log/instance.log


# store the parameters
export compute_user=${compute_user}
export cdc_url=${cdc_url}

echo "compute_user = ${compute_user} and cdc_url = ${cdc_url}" >> /var/log/instance.log

yum update -y
yum install wget -y
yum install unzip -y
yum install jq -y
yum install expect -y
yum install nc -y
# install docker
yum install -y docker
# install java 11
yum install java-11-openjdk -y
# set environment
echo vm.max_map_count=262144 >> /etc/sysctl.conf
sysctl -w vm.max_map_count=262144
echo "    *       soft  nofile  65535
    *       hard  nofile  65535" >> /etc/security/limits.conf
sed -i -e 's/1024:4096/65536:65536/g' /etc/sysconfig/docker
# enable docker    
usermod -a -G docker ec2-user
service docker start
chkconfig docker on
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "Tool installation finished" >> /var/log/instance.log

# install CDC Workshop Setup
cd /home/${compute_user}
wget ${cdc_url}
unzip main.zip
chown ${compute_user}:${compute_user} -R /home/${compute_user}/confluent-cdc-workshop-main/
rm main.zip
chown ${compute_user}:${compute_user} -R confluent-cdc-workshop-main/*
cd /home/${compute_user}/confluent-cdc-workshop-main/terraform/gcp/mysql_postgres
mv docker/ /home/${compute_user}/
cd /home/${compute_user}/
rm -rf confluent-cdc-workshop-main/

echo "Git Repo download finished" >> /var/log/instance.log

# run docker compose
cd docker
docker-compose up -d
echo "Mysql and Postgres started" >> /var/log/instance.log