# Oracle DB Enterprise Edition running on AWS as docker container

I did prepare an AWS AMI with an Oracle 21c including all data, permissions etc. we need for a CDC Workshop with the Confluent Oracle CDC Source Connector. To create this AMI you need to follow the [manual step](manualstep.md) or ask Confluent for help.

## Prerequisites

* Having an AWS Account, with AWS Key and Secret
* having AWS compute key pair created
* Having an AMI prepared with all the software documented in [manual step](manualstep.md). Ask Confluent to enable a correct AMI for you. If you are Confluent employee check AMIs in Region Frankfurt with name `oracle21c_ami4CDC`
* terraform installed (I am running v.1.6.6)
* knowing your current Public IP Address, see [my IP](https://www.myip.com/)
* Accept the OTN License (for playing with Oracle), see [OTN License](https://www.oracle.com/downloads/licenses/standard-license.html)
* optional you could run SQL Developer on your desktop


## Getting Started

Before executing terraform for oracle21c-lab-environment deployment, change the [env-var.sample](env-vars.sample) and store it as `env-vars`.
Add your aws_access_key, aws_secret_key. aws_region, myip and AMI ID and as well your own ssh private key should be used. see ssh_key_name:.

```bash
# change to your values
cat > $PWD/env-vars <<EOF
export TF_VAR_aws_access_key=AWSKEY
export TF_VAR_aws_secret_key=AWSSECRET
export TF_VAR_aws_region=eu-central-1
export TF_VAR_ssh_key_name=cdcworkshop
export TF_VAR_instance_count=1
export TF_VAR_myip=X.Y.X.Y/32
export TF_VAR_ami_oracle21c=ami-YOURAMIID
EOF

# Run terraform
cd terraform/aws/oracle21c
source env-vars
terraform init
terraform plan
terraform apply
```

> If you need more than one instance of compute services, e.g. want to give the workshop attendees each on DB
> set the TF_VAR_instance_count variable to the amount of attendees.

Terraform will deploy the complete oracledb12c compute service and start the docker container.
The output of terraform will show you all the endpoints for you database access:

```bash
Outputs:

OracleAccess = " sys/PW@ORCLCDB as sysdba or sys/PW@ORCLPDB1 as sysdba or ordermgmt/PW@ORCLPDB1  Port:1521  HOST:PUB-IP "
PublicIPs = " Public IP Adresses are PUB-IP "
SSH = " SSH  Access: ssh -i ~/keys/yourpriv.pem ec2-user@PUB-IP "
```

It takes a little while till everything is up and running in aws compute instance. 
Login into cloud compute instance via ssh and check status:

```bash 
ssh -i ~/keys/yourawskeypair-private.pem ec2-user@PUB-IP
echo $LD_LIBRARY_PATH
echo $PATH
sudo docker images ls
sudo docker ps
# CONTAINER ID     IMAGE                       COMMAND                  CREATED       ...
# 3c8c05402956     oracle/database:21.3.0-ee   "/bin/sh -c 'exec $O…"   6 hours ago   ...
```

If docker ps gives you a result (see above), than your DB is running. You need not to execute 1. and 2.
1. The Oracle DB should run as container. If not do the following:

```bash
export CONTAINERID=$(sudo docker ps -a | awk  'NR==2 {print $1}')
sudo docker start $CONTAINERID
```

2. If no oracle21c docker container is running, start it by creating a new container

```bash
docker run \
--name oracle21c \
-p 1521:1521 \
-p 5500:5500 \
-e ORACLE_PDB=ORCLPDB1 \
-e ORACLE_PWD=confluent123 \
-e ORACLE_MEM=4000 \
-v /opt/oracle/oradata \
-d oracle/database:21.3.0-ee
```

With running database you should have to access now via SQL Developer and sqlplus (on aws compute).

```bash
# AWS Compute via SSH login
ssh -i ~/keys/yourkey.pem ec2-user@PUB-IP
# try sysdba to CDB
sqlplus sys/PW@ORCLCDB as sysdba 
# try sysdba to PDB
sqlplus sys/PW@ORCLPDB1 as sysdba
# try local user in PDB
sqlplus ordermgmt/kafka@ORCLPDB1
```

From your desk top use SQL Developer oder SQL*Plus with Easy Connect:

```bash
# try sysdba to CDB with easy connect
sqlplus sys/confluent123@//54.93.251.54:1521/ORCLCDB as sysdba
# try sysdba to PDB
sqlplus sys/confluent123@//54.93.251.54:1521/ORCLPDB1 as sysdba
# try local user in PDB
sqlplus ordermgmt/kafka@//54.93.251.54:1521/ORCLPDB1
```
# Destroy DB aws compute instance

Destroy the cloud compute DB Service:

```bash
terraform destroy
```

# License

For Oracle we will use an [OTN License](https://www.oracle.com/downloads/licenses/standard-license.html). 
"Oracle grants You a nonexclusive, nontransferable, limited license to internally use the Programs, subject to the restrictions stated in this Agreement, only for the purpose of developing, testing, prototyping, and demonstrating Your application and only as long as Your application has not been used for any data processing, business, commercial, or production purposes, and not for any other purpose."

For AWS Compute Instance you need a working account.