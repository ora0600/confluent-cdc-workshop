#########################################################
######## Confluent Kafka-Rest 5.3 Dev Instance ##########
#########################################################

data "template_file" "oracle_instance" {
  template = file("utils/instance.sh")
}
