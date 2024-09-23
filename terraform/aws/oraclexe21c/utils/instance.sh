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
cd /home/ec2-user/confluent-cdc-workshop-main/terraform/aws/oraclexe21c
mv docker /home/ec2-user/
cd /home/ec2-user/
rm -rf confluent-cdc-workshop-main/

# run docker compose
cd docker
# docker-compose up -d is not working anymore, do not know why. Instead start the image direclty, this is working. docker-compose up -d errored with invalid reference format
docker run --name oracle21c \
-p 1521:1521 -p 5500:5500 -p 8080:8080 \
-e ORACLE_SID=XE \
-e ORACLE_PDB=XEPDB1 \
-e ORACLE_PWD=confluent123 \
-e ORACLE_MEM=4000 \
-e ORACLE_CHARACTERSET=AL32UTF8 \
-e ENABLE_ARCHIVELOG=true \
-v /opt/oracle/oradata \
-v ./scripts:/opt/oracle/scripts/setup \
-d container-registry.oracle.com/database/express:21.3.0-xe

# Wait 60 seconds before preparing the database for CDC
sleep 60

# Prepare the database for CDC including data
docker exec oracle21c /bin/bash -c "bash /opt/oracle/scripts/setup/00_setup_cdc.sh"
