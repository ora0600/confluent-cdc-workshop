# Build AWS Compute and install Oracle on Docker, create an AMI and use it then later with terraform

This is a manual step guide, how to build an Oracle environment for AWS with docker. Please follow the license rules from Oracle.

1. Create AWS Compute [Key Pairs](https://eu-central-1.console.aws.amazon.com/ec2/home?region=eu-central-1#KeyPairs:):
   Name: workshopkey
   Key Pair type: RSA
   in .pem format
   Add tag owner=your Email
   Store workshopkey.pem on your disk.

2. Create AWS EC2 Compute from [ECS Console](https://eu-central-1.console.aws.amazon.com/ec2/home?region=eu-central-1#Home:):
   Region: FRANKFURT
   Name: cmoradb21c
   AMI: Amazon Linux 2 Kernel 5.10 AMI 2.0.20240529.0 x86_64 HVM gp2 - ami-06801a226628c00ce
   Architecture: 64-bit (x86)
   Instance-TYpe: t2.xlarge
   Key pair: workshopkey
   Use the Default VPC, 
   Use a Public Subnet
   Autoassign Public IP : enable
   Create Security group: cmoradb21c_sg
   Port 22 for ssh Source Type: custom Source: MyIP=MYIP/32
   Port 1521 DB Source Type: custom Source: MyIP=MYIP/32
   Port 5500 EM Source Type: custom Source: MyIP=MYIP/32
   Storage 1 x 100 GiB
Launch Instance: After Launch add TAG owner=Your Email

## set permission to key
Your key need the correct permission otherwise you would not able to ssh into computer instance.

```bash
chmod 400 ~/keys/workshopkey.pem
```

## ssh into instance and do the installation:

Prepare everything you need:

```bash
# login
ssh -i workshopkey.pem ec2-user@PUB-IP
# Update the compute service with software
sudo su -
yum update -y
# install git
yum install git -y
# install java
yum install java-1.8.0-openjdk-devel.x86_64 -y
# install docker
yum install -y docker
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

# install Oracle container
mkdir -p /home/ec2-user/software
chown ec2-user:ec2-user -R /home/ec2-user/software
cd /home/ec2-user/software
# Get oracle Docker images
git clone https://github.com/oracle/docker-images.git
cd docker-images/OracleDatabase/SingleInstance/dockerfiles/21.3.0
# Download the Binaries in docker-images/OracleDatabase/SingleInstance/dockerfiles/21.3.0
# get download zip from here http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
# the file name is LINUX.X64_213000_db_home.zip
# scp to aws compute: 
# on local desktop: go into dir of binararies ~/Downloads, with scp it takes a while to copy 3.11 GB
scp -i cdcworkshop.pem LINUX.X64_213000_db_home.zip ec2-user@PUB-IP:~/.
# in aws ssh session
mv /home/ec2-user/LINUX.X64_213000_db_home.zip .
# Download sql client wget https://download.oracle.com/otn_software/linux/instantclient/2114000/instantclient-sqlplus-linux.x64-21.14.0.0.0dbru.zip 
# Installation Notes: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
scp -i cdcworkshop.pem instantclient-basic-linux.x64-21.14.0.0.0dbru.zip ec2-user@PUB-IP:~/.
mkdir -p /home/ec2-user/software/oracle
mv /home/ec2-user/instantclient-basic-linux.x64-21.14.0.0.0dbru.zip /home/ec2-user/software/oracle       
cd /home/ec2-user/software/oracle      
unzip instantclient-basic-linux.x64-21.14.0.0.0dbru.zip
rm instantclient-basic-linux.x64-21.14.0.0.0dbru.zip 
cd instantclient_21_14
export LD_LIBRARY_PATH=/home/ec2-user/software/oracle/instantclient_21_14:$LD_LIBRARY_PATH
wget https://download.oracle.com/otn_software/linux/instantclient/214000/instantclient-sqlplus-linux.x64-21.4.0.0.0dbru.zip 
unzip -d /home/ec2-user/software/oracle instantclient-sqlplus-linux.x64-21.4.0.0.0dbru.zip
export PATH=$LD_LIBRARY_PATH:$PATH
#try
sqlplus
# add in /home/ec2-user/.bash_profile
export LD_LIBRARY_PATH=/home/ec2-user/software/oracle/instantclient_21_14:$LD_LIBRARY_PATH
export PATH=.....:$LD_LIBRARY_PATH
# save .bash_profile
# Change Owner 
chown -R ec2-user:ec2-user docker-images/
chown -R ec2-user:ec2-user oracle/
# Follow the steps from here: https://github.com/oracle/docker-images/tree/main/OracleDatabase/SingleInstance
cd dockerimages/OracleDatabase/SingleInstance/dockerfiles/
# Build image for Enterprise Edition
./buildContainerImage.sh -v 21.3.0 -e –I
# Run the database as ec2-user
docker run \
--name oracle21c \
-p 1521:1521 \
-p 5500:5500 \
-e ORACLE_PDB=ORCLPDB1 \
-e ORACLE_PWD=yourPassword \
-e ORACLE_MEM=4000 \
-v /opt/oracle/oradata \
-d oracle/database:21.3.0-ee
# The database need s to be 15 minutes to be up and running
docker ps
```

Database is now running. Now we need to add everything for Confluent Oracle CDC Source Connector and install sample data.

## Prepare the database for CDC

get shell into oracleDB container, and check is DB is running

```bash
docker exec -it oracle21c /bin/bash
ps -ef | grep ora
export TNS_ADMIN=/opt/oracle/homes/OraDB21Home1/network/admin/
# It takes a while till services are up and running
sqlplus /nolog
SQL> connect sys/yourPassword@ORCLCDB as sysdba
SQL> show pdbs
#    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
#---------- ------------------------------ ---------- ----------
#         2 PDB$SEED                       READ ONLY  NO
#         3 ORCLPDB1                       READ WRITE NO
# If you see two PDBs the Oracle is ready configured      
SQL> exit;   
# check services
lsnrctl status
#Services Summary...
#Service "1a0e330b9eaa0b62e063020011ac10bd" has 1 instance(s).
#  Instance "ORCLCDB", status READY, has 1 handler(s) for this service...
#Service "ORCLCDB" has 1 instance(s).
#  Instance "ORCLCDB", status READY, has 1 handler(s) for this service...
#Service "ORCLCDBXDB" has 1 instance(s).
#  Instance "ORCLCDB", status READY, has 1 handler(s) for this service...
#Service "orclpdb1" has 1 instance(s).
#  Instance "ORCLCDB", status READY, has 1 handler(s) for this service...
#The command completed successfully
# ORCLDBC is running and ORCLPDB1 

# logging into container
sqlplus sys/yourPassword@ORCLCDB as sysdba
SQL> select instance_name, con_id, version from v$instance;
# better way to where I AM
SQL> select decode(sys_context('USERENV', 'CON_NAME'),'CDB$ROOT',sys_context('USERENV', 'DB_NAME'),sys_context('USERENV', 'CON_NAME')) DB_NAME, 
            decode(sys_context('USERENV','CON_ID'),1,'CDB','PDB') TYPE 
       from DUAL;
SQL> connect sys/yourPassword@ORCLPDB1 as sysdba
SQL> select instance_name, con_id, version from v$instance;
SQL> select dbid, con_id, name from v$pdbs;
SQL> alter session set container = ORCLPDB1;
# better way to check
SQL> select decode(sys_context('USERENV', 'CON_NAME'),'CDB$ROOT',sys_context('USERENV', 'DB_NAME'),sys_context('USERENV', 'CON_NAME')) DB_NAME, 
            decode(sys_context('USERENV','CON_ID'),1,'CDB','PDB') TYPE 
       from DUAL;
SQL> exit
# leave the docker container
exit
# add tnsnames.ora locally in ec2, as ec2-user
cd /home/ec2-user/software/oracle
echo "ORCLCDB=localhost:1521/ORCLCDB
ORCLPDB1= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = ORCLPDB1)
  )
)" > tnsnames.ora
# Add into /home/ec2-user/.bash_profile
export TNS_ADMIN=/home/ec2-user/software/oracle
source .bash_profile
# try to connect without errors
sqlplus sys/yourPassword@ORCLCDB as sysdba

# create user ordermgmt, scripts avaiable in github
cd /home/ec2-user/software/oracle
sqlplus sys/yourPassword@ORCLPDB1 as sysdba
SQL>  @scripts/01_create_user.sql
SQL> connect ordermgmt/kafka@ORCLPDB1
sql> @scripts/02_create_schema_datamodel.sql
sql> @scripts/04_load_data.sql
SQL> exit

# Create CDC User with Roles and privileges for pDB
sqlplus sys/yourPassword@ORCLPDB1 as sysdba
sql> @scripts/07_21c_privs.sql
sql> exit;

# Enable archive log into DB
sudo su -
docker exec -it oracle21c /bin/bash
export ORACLE_SID=ORCLCDB
sqlplus /nolog
sql> CONNECT sys/yourPassword AS SYSDBA
        -- Turn on Archivelog Mode
sql> shutdown immediate
sql> startup mount
sql> alter database archivelog;
sql> alter database open;
        -- Should show "Database log mode: Archive Mode"
sql> archive log list
sql> ALTER SESSION SET CONTAINER=cdb$root;
sql> ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
sql> ALTER SESSION SET CONTAINER=ORCLPDB1;
sql> ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
sql> exit;
exit;
# back as ec2-user
exit
```

## Database is prepared

check external access with sql developer I am running version 23.1
I do create two connections in sqldeveloper
1. oracle21c aws PDB1 as sysdba CDC
   User: sys
   PW: yourPassword
   Connection type: BASIC
   HOST: PUB-IP
   Port: 1521
   service name: ORCLPDB1
2. oracle21c aws CDB1 as sysdba CDC
   User: sys
   PW: yourPassword
   Connection type: BASIC
   HOST: PUB-IP
   Port: 1521
   service name: ORCLCDB
3. oracle21c aws PDB1 as ordermgmt CDC
   User: ordermgmt
   PW: kafka
   Connection type: BASIC
   HOST: PUB-IP
   Port: 1521
   service name: ORCLPDB1

Database should work also outside Compute Instance.

## Stop DB container

```bash
sudo docker ps
sudo docker stop oracle21c
# image is still there
sudo docker image ls
```

## Create AMI from Compute Instance

Now store AMI image from compute service console, so that we can create a new compute with everything implemented by terraform
* Go to the AWS console
* go to your EC2 dashboard : in the instances list
   * select your instance, right click on your instance
   * select image and Template -> create image
   * Give AMI a 
      Name: oracle21c-ami-image-for-CDC
      Description: oracle21c-ami-image-for-CDC
      Add tags:
      owner_email=YOU EMAIL
      content=oracle21-ee
      AMI NAME: oracle21c-ami-image-for-CDC
      AMI ID: ami-XXXXXX
      Change NAME: oracle21c_ami4CDC 

Now, you can use the AMI with terraform. Just enter AMI ID into `.accounts`:

```bash
export TF_VAR_ami_oracle21c=ami-XXXXXXX
```

To share with other AWS accounts [follow the link]( https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/sharingamis-explicit.html)
It takes a while till image is created, check AMI status in aws console.

back to [Deployment-Steps Overview](../README.MD)