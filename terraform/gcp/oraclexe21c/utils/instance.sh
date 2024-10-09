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
#yum install -y docker
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
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "Tool installation finished" >> /var/log/instance.log


# install CDC Workshop Setup
cd /home/${compute_user}
wget ${cdc_url}
unzip main.zip
chown ${compute_user}:${compute_user} -R /home/${compute_user}/confluent-cdc-workshop-main/
rm --force main.zip
chown ${compute_user}:${compute_user} -R confluent-cdc-workshop-main/*
cd /home/${compute_user}/confluent-cdc-workshop-main/terraform/gcp/oraclexe21c
mv docker/ /home/${compute_user}/
cd /home/${compute_user}/
rm -rf confluent-cdc-workshop-main/

echo "Git Repo download finished" >> /var/log/instance.log

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

echo "Oracle started" >> /var/log/instance.log

# Wait 60 seconds before preparing the database for CDC
sleep 60

# Prepare the database for CDC including data
docker exec oracle21c /bin/bash -c "bash /opt/oracle/scripts/setup/00_setup_cdc.sh"