#########################################################
######## Confluent Kafka-Rest 5.3 Dev Instance ##########
#########################################################

data "template_file" "confluent_instance" {
  template = file("utils/instance.sh")

  vars = {
    confluent_cdc_workshop           = var.confluentcdcsetup
  }
}
