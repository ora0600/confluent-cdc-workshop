#!/bin/bash

echo "Instance Startup script is started" > /var/log/instance.log


# store the parameters
export compute_user=${compute_user}
export cdc_url=${cdc_url}

echo "compute_user = ${compute_user} and cdc_url = ${cdc_url}" >> /var/log/instance.log

# Do update for better security
yum update -y
yum install wget -y
yum install unzip -y
yum install jq -y
yum install expect -y
yum install nc -y
# install docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --allowerasing -y
systemctl start docker
# install java 11
yum install java-11-openjdk -y
# set environment
echo vm.max_map_count=262144 >> /etc/sysctl.conf
sysctl -w vm.max_map_count=262144
echo "    *       soft  nofile  65535
    *       hard  nofile  65535" >> /etc/security/limits.conf
# docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
mv docker-compose /usr/local/bin && sudo chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose 

echo "Tool installation finished" >> /var/log/instance.log

# Azure sizing volume of os disk
lvextend --size +4GB --resizefs /dev/rootvg/tmplv   
lvextend --size +3GB --resizefs /dev/rootvg/homelv  
lvextend --size +22GB --resizefs /dev/rootvg/varlv  
lvextend --size +10GB --resizefs /dev/rootvg/rootlv 
lvextend --size +1GB --resizefs /dev/rootvg/usrlv   


# install CDC Workshop Setup
cd /home/${compute_user}
wget ${cdc_url}
unzip main.zip
chown ${compute_user}:${compute_user} -R /home/${compute_user}/confluent-cdc-workshop-main/
rm --force main.zip
chown ${compute_user}:${compute_user} -R confluent-cdc-workshop-main/*
cd /home/${compute_user}/confluent-cdc-workshop-main/terraform/azure/mysql_postgres
mv docker/ /home/${compute_user}/
cd /home/${compute_user}/
rm -rf confluent-cdc-workshop-main/

echo "Git Repo download finished" >> /var/log/instance.log

# run docker compose
cd docker
docker-compose up -d
echo "Mysql and Postgres started" >> /var/log/instance.log