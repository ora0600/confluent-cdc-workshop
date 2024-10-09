# Deploy Confluent S3 Sink Connector


> [!IMPORTANT]
> Please check before if you have the [correct permission in AWS](https://docs.confluent.io/cloud/current/connectors/cc-s3-sink/cc-s3-sink.html#user-account-iam-policy)

Deploy the S3 Sink Connector. 

```bash
# Deploy connector
cd ../ccloud-sink-s3-connector
source .ccloud_env
terraform init
terraform plan
terraform apply
```

Terraform will output after deployment:

```bash
# Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
# Outputs:
# A00_S3_SINK_Connector = "Login into your Confluent Cloud Console and check in your cluster if S3 Sink Connector is running"
```

![S3 Sink connector is running](img/s3_connector.png)

We will sink `all_products` to S3.

Default offset setting is `Jump back to the earliest message per topic (default)` but you can start where you want. See [manage offset for Sink Connectors](https://docs.confluent.io/cloud/current/connectors/offsets.html?ajs_aid=5ed44563-a71c-44cb-86d1-9ea6632b3d06&ajs_uid=55951#custom-offsets-sink-proc). I have configured S3FullAccess Policy.

After S3 Connector deployment you will see no data in S3.

Try to insert a new product:
```bash
ssh -i ~/keys/cmawskeycdcworkshop.pem ec2-user@x.x.x.x
# INSERT
docker exec -it postgres psql -U postgres-user -d customers
customers=# select * from product;
# product_id |    name     
#------------+-------------
#          1 | Product 1
# ...
#         100| Product 100
# break with q
# best experience is to insert and have in parallel a view on the taopic viewer for all_products 
# Now, best selling amazon products Top 5 products from amazon.de
customers=# INSERT INTO PRODUCT VALUES (101, 'Arnomed Disposable Gloves Black');
customers=# INSERT INTO PRODUCT VALUES (102, 'ANYCUBIC PLA 3D Printer Filament');
customers=# INSERT INTO PRODUCT VALUES (103, 'EQM | ECO-301 | Isopropanol - Isopropylalkohol 99.9% | 1L');
customers=# INSERT INTO PRODUCT VALUES (104, '1000 ml Glycerol 99.5% + 1000 ml Propylene Glycol 99.5%');
customers=# INSERT INTO PRODUCT VALUES (105, 'EUROPAPA® Nitrile Gloves Box of 100 Disposable Gloves');
customers-# \q
$ exit
```

Now products are flying into `all_products` topic:
![new product](img/newproduct.png)

But still nothing visible in S3. It takes a while and then you will see the avro file.
![s3 upload](img/s3upload.png)

check which connectors are running:

```bash
confluent connect cluster list --cluster $TF_VAR_clusterid --environment $TF_VAR_envid
```

back to [Deployment-Steps Overview](../README.md) or continue with Sink Cloud Services [Redshift](../aws-redshift/README.md)