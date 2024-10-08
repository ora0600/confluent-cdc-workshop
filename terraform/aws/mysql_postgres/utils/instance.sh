#!/bin/bash
yum update -y
yum install wget -y
yum install unzip -y
yum install jq -y
yum install expect -y
yum install nc -y
# install docker
yum install -y docker
# install java 11
amazon-linux-extras install java-openjdk11 -y
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

# install CDC Workshop Setup
cd /home/ec2-user
wget ${confluent_cdc_workshop}
unzip main.zip
chown ec2-user:ec2-user -R /home/ec2-user/confluent-cdc-workshop-main/
rm main.zip
chown ec2-user:ec2-user -R confluent-cdc-workshop-main/*
cd /home/ec2-user/confluent-cdc-workshop-main/terraform/aws/mysql_postgres
mv docker /home/ec2-user/
cd /home/ec2-user/
rm -rf confluent-cdc-workshop-main/

# run docker compose
cd docker
docker-compose up -d
