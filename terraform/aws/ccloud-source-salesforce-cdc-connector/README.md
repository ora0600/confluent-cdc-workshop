# Deploy Salesforce CDC Source connector

It is expected that you did the [preparation in Salesforce](setup_salesforce.md).
Before Deployment please login into Salesforce with your credentials you saved in `terraform/aws/.accounts`. Go to [Salesforce-Development](https://login.salesforce.com)) or use you own Salesforce-Sandbox. Please let the Salesforce App open, we add a contact later.
If you did login successfully, then please do the deployment:

```bash
# Deploy connector
cd ../ccloud-source-salesforce-cdc-connector
source .ccloud_env
terraform init
terraform plan
terraform apply
```

Terraform will output after a successful deployment:

```bash
# Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
# Outputs:
# A00_SALES_CDC_Connector = "Login into your Confluent Cloud Console and check in your cluster if Salesforce CDC Source Connector is running"
```

![salesforce connector is running](img/salesforce_connector.png)

Terraform need a while to close. But the connector is working already.
The connector is using the deployed topic `salesforce_contacts`. This was created via `ccloud_cluster` deployment including the schema.

Try to insert a new Contact record via the Salesforce UI. [Login](https://login.salesforce.com/) and click on the left upper **App Launcher icon** and search for **Contacts**
![salesforce Contacts](img/salesforce_find_contacts.png)

Click on **New** (upper right corner) and create a new Contact. And click **save**.
![salesforce new Contacts](img/salesforce_new_contacts.png)

Try to find this record in Confluent Cloud console topic viewer.
![salesforce change Topic](img/salesforce_change_topic_insert.png)

Salesforce CDC is working. So, we are finished with this lab.
With this last Source Connector we should now have all CDC Source Connectors running.
![all CDC Connector](img/all_cdc_connectors.png)

back to [Deployment-Steps Overview](../README.md) or continue with [data processing](../dataprocessingREADME.md).
