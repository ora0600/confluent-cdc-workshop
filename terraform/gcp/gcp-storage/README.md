# Deploy Google Storage bucket

The Storage API has been enabled. See [tutorial](https://cloud.google.com/storage/docs/terraform-create-bucket-upload-object)

Deploy the Google Storage Bucket via:

```bash
cd gcp-storage
source .gcp_env
terraform init 
terraform plan
terraform apply
``` 

If you did deploy successfully with terraform you will get the following output:

```bash
#A00_bucket_details = {
#  "autoclass" = tolist([])
#  "cors" = tolist([])
#  "custom_placement_config" = tolist([])
#  "default_event_based_hold" = false
#  "effective_labels" = tomap({
#    "goog-terraform-provisioned" = "true"
#  })
#  "enable_object_retention" = false
#  "encryption" = tolist([])
#  "force_destroy" = true
#  "id" = "cdc-workshop-b440"
#....
#A02_bucket_name = "cdc-workshop-b440"
```

You can check in your [Google Storage Console](https://console.cloud.google.com/storage/browser), if bucket exists:

* Bucket_name: cmcdc-workshop-XXX
* Aws Region: europe-west1 (Belgium)

![S3 bucket](img/s3bucket.png)


back to [Deployment-Steps Overview](../README.md) or continue with the [Google Storage Sink Connector](../ccloud-sink-storage-connector/README.md)