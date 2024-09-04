# Oracle CDC Source Connector

Oracle Database is running and now we will deploy CDC Connector:

   
```bash
cd ../ccloud-source-oracle-cdc-connector/
source .ccloud_env 
terraform init
terraform plan
terraform apply
```

Terraform should deploy the connector successfully with this output:

```bash
# Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
# Outputs:
# A00_Oracle_CDC_Connector = "Login into your Confluent Cloud Console and check in your cluster if Oracle CDC Source Connector is running"
``` 

The connector is creating a couple of topics with the correct schema aligned:

* First we will see all the table change topics in the format : `<PDBNAME>.<DBSCHEMA>.<TABLENAME>`. The first initial load of all data (snapshot) will be executed first
* Later we have the redolog topic `XEPDB1.ORDERMGMT.REDOLOG` if a change is happing on the Oracle DB.

The connector will create all topics and schemas for the database table we want to integrate. In our case we configured to use the following tables
`"table.inclusion.regex" = "XEPDB1[.]ORDERMGMT[.](ORDER_ITEMS|ORDERS|EMPLOYEES|PRODUCTS|CUSTOMERS|INVENTORIES|PRODUCT_CATEGORIES|CONTACTS|NOTES|WAREHOUSES|LOCATIONS|COUNTRIES|REGIONS)"`

The result is a list of topics including AVRO schemas.
![CDC TOPICS](img/cdc_topics.png)

What the connector is doing first, is doing a snapshot of all tables we want to have in our cluster (see `"table.inclusion.regex"`). A so called initial load.
E.g. in topic `XEPDB1.ORDERMGMT.CONTACTS` we do have an amount of 319 events so far.
![contact TOPIC](img/topic_contact_319.png)

Please check the current dataset in our database:

```bash
ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@x.x.x.x
sqlplus ordermgmt/kafka@XEPDB1
SQL> select count(*) from CONTACTS;
  COUNT(*)
----------
       319
SQL> exit;
exit      
```

As expected we got the same amount of data. So now, we can try if the connector is really doing CDC. 
For a first demo please add yourself as new contact. Before doing that create a new customer.

```bash
ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@18.195.50.248
sqlplus ordermgmt/kafka@XEPDB1
# First the customer, insert your company
SQL> insert into customers (name, address, website, credit_limit) values ('Confluent Germany GmbH', 'Munich', 'www.confluent.de', 100000);
SQL> commit;
# Commit complete.
SQL> select customer_id from customers where name ='Confluent Germany GmbH';
CUSTOMER_ID
-----------
        323
# Now the contact , with the ID of the created customer, Please do the insert more than one time , e.g. 4 time. We will do a de-duplication later.    
SQL> insert into contacts values ("ORDERMGMT"."ISEQ$$_75756".nextval, 'Carsten', 'Muetzlitz', 'cmutzlitz@confluent.io', '030 43579888',323 );
SQL> commit;
SQL> insert into contacts values ("ORDERMGMT"."ISEQ$$_75756".nextval, 'Carsten', 'Muetzlitz', 'cmutzlitz@confluent.io', '030 43579888',323 );
SQL> commit;
SQL> insert into contacts values ("ORDERMGMT"."ISEQ$$_75756".nextval, 'Carsten', 'Muetzlitz', 'cmutzlitz@confluent.io', '030 43579888',323 );
SQL> commit;
SQL> insert into contacts values ("ORDERMGMT"."ISEQ$$_75756".nextval, 'Carsten', 'Muetzlitz', 'cmutzlitz@confluent.io', '030 43579888',323 );
SQL> commit;
SQL> exit;
exit;
```

Now, the connector has created the redo log topic `XEPDB1.ORDERMGMT.REDOLOG` and the heartbeat topic `lcc-xxxxx-XEPDB1-heartbeat-topic`. The heartbeat topic if for really less update frequency. From this point forward, all changes will be stored in the redo log topic in the correct sequence (hence the redo log is limited to run with a single partition).
We do see both changes know in redolog topic, first the entry for insert into customers
![ REDOLOG TOPIC customers](img/customerentry_redolog_topic.png)

second the entry for insert into contacts
![ REDOLOG TOPIC contacts](img/contactsentry_redolog_topic.png)

And finally the new entries are also visible in table topics, first new customer `Confluent Germany GmbH`
![ TOPIC topic customers](img/customer_topic.png)

And the contact `Carsten Muetzlitz`
![ TOPIC topic contacts](img/contacts_topic.png)

The connector is working pretty well.

back to [Deployment-Steps Overview](../README.MD) or continue with the other [DB Services MySQL and PostGreSQL](../mysql_postgres/Readme.md )
