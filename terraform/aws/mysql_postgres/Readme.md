# Deploy mySQL and PostgreSQL DB Service as Compute service in AWS Cloud

This docker-compose based setup includes:

- mySQL
- PostGreSQL

We will deploy it to AWS Compute.

```bash
cd ../mysql_postgres/
source .aws_env
terraform init 
terraform plan
terraform apply
```

This deployment will deploy mysql and postgresql docker container in AWS compute.
Terraform output is:

```bash
# Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
# Outputs:
# A00_instance_details = {
# "ami" = ...
# A01_PUBLICIP = "x.x.x.x"
# A02_HOSTNAME = "ec2-x-x-x-x.eu-central-1.compute.amazonaws.com"
# A03_SSH = "SSH  Access: ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@x.x.x.x "
# A03_pls_cli_access = "postgres cli: psql -h x.x.x.x -p 5432 -U postgres-user -d customers"
# A04_mysqlsh_cli_access = "mysql shell: mysqlsh mysqluser@x.x.x.x:3306/demo"
```

The deployment takes a short while till everything is up and running. Login via ssh: 

```bash 
ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@x.x.x.x
# If Cloud-init logfiles scrolls content, then setup is not finished yet
sudo tail -f /var/log/cloud-init-output.log
# if you see Cloud-init v. 19.3-46.amzn2.0.2 finished at...  then installation and setup is finished
press CTRL+c to close tail.
# Go To docker and check if it is running
cd docker  
sudo docker-compose ps 
#  Name                Command              State                          Ports                       
#------------------------------------------------------------------------------------------------------
#mysql      docker-entrypoint.sh mysqld     Up      0.0.0.0:3306->3306/tcp,:::3306->3306/tcp, 33060/tcp
#postgres   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp  

# connect into mysql container
sudo docker exec -it mysql bash -l
# Check backup in enabled (prereq for CDC Connector)
root@mysql > cat /etc/mysql/conf.d/mysql.cnf
# Log_bin = incremental back is enabled
# log_bin           = mysql-bin
exit;
exit;
```

A mySQL DB should have incremental backup enable. See above.
You can use your mysql-Shell Desktop tool:

```bash
# Install mySQL Shell on mac os https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install-macos-quick.html
# I installed this one: macOS 14 (x86, 64-bit), DMG Archive
# see reference https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-commands.html
# with password mysqlpw
mysqlsh mysqluser@PUBIP:3306/demo
SQL> show tables;
#+----------------+
#| Tables_in_demo |
#+----------------+
#| accounts       |
#+----------------+
SQL> select * from accounts;
#+-----------+------------+------------+----------------+---------------+----------------+---------------+---------------------+----------------------
#| account_id | first_name | last_name  | email         | phone         | address        | country       | create_ts           | update_ts           |
#+------------+------------+------------+---------------+---------------+----------------+---------------+---------------------+---------------------+
#| a001       | Robin      | Moffatt    | robin@conflue | +44 123 456 78| 22 Acacia Avenu| United Kingdom| 2024-08-15 12:21:36 | 2024-08-15 12:21:36 |
#| a002       | Sidoney    | Lafranconi | slafranconi0@a| +44 908 687 66| 40 Kensington P| United Kingdom| 2024-08-15 12:21:36 | 2024-08-15 12:21:36 |
#| a003       | Mick       | Edinburgh  | medinburgh1@e | +44 301 837 65| 27 Blackbird La| United Kingdom| 2024-08-15 12:21:36 | 2024-08-15 12:21:36 |
#| a004       | Merrill    | Stroobant  | mstroobant2@c | +44 694 224 49| 4053 Corry Circ| United Kingdom| 2024-08-15 12:21:36 | 2024-08-15 12:21:36 |
#| a005       | Cheryl     | Vern       | cvern3@istockp| +44 978 613 72| 993 Loomis Junc| United Kingdom| 2024-08-15 12:21:36 | 2024-08-15 12:21:36 |
#| a006       | Aura       | Cota       | acota4@dion.ne| +44 516 539 43| 5106 Waxwing Pa| United Kingdom| 2024-08-15 12:21:36 | 2024-08-15 12:21:36 |
#| a007       | Carsten    | Muetzlitz  | cmutzlitz@conf| +49 30 200202 | 13595 Berlin   | Germany       | 2024-08-15 12:21:36 | 2024-08-15 12:21:36 |
#+------------+------------+------------+---------------+---------------+----------------+---------------+---------------------+---------------------+
7 rows in set (0.0370 sec)
SQL> \quit
```

If you have no mysql-Shell installed on your Mac, you can do the same in the docker container:

```bash
ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@x.x.x.x
sudo docker exec mysql mysql -umysqluser -pmysqlpw demo -e "select * from accounts;"
exit
```

For PostgreSQL you can use psql cli tool if you have it installed:

```bash
# install psql on mac
# brew install libpq
# echo 'export PATH="/usr/local/Cellar/libpq/16.3/bin:$PATH"' >> ~/.zshrc
# echo 'export PATH="/usr/local/Cellar/libpq/16.3/bin:$PATH"' >> ~/.bash_profile
# ln -s /usr/local/Cellar/libpq/10.3/bin/psql /usr/local/bin/psql
#  with password postgres-pw, exit
psql -h PUBIP -p 5432 -U postgres-user -d customers`
customers=# \dt
#Schema |     Name     | Type  |     Owner     
#--------+--------------+-------+---------------
# public | city         | table | postgres-user
# public | country      | table | postgres-user
# public | order_status | table | postgres-user
# public | product      | table | postgres-user
# public | sale         | table | postgres-user
# public | status_name  | table | postgres-user
# public | store        | table | postgres-user
# public | users        | table | postgres-user
customers=# select * from users;
# user_id |   name   
#---------+----------
#       1 | User 1
#       2 | User 2
# ...
customers=# \q
```

If you have no psql cli installed on your Mac, you can do the same in the docker container:

```bash
ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@x.x.x.x
# with password postgres-pw
sudo docker exec -it postgres psql -U postgres-user -d customers
# show tables
customers=# \dt
customers=# select * from users;
# enter q to break the select
customers-# \q
exit
```

DB Services MySQL and PostGeSQL are running.

back to [Deployment-Steps Overview](../README.MD) or continue with the [MySQL CDC Connector Setup](../ccloud-source-mysql-cdc-connector/README.md )