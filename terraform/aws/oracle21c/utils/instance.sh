#!/bin/bash
sudo yum update -y
echo "Start Oracle Database"
export CONTAINERID=$(sudo docker ps -a | awk  'NR==2 {print $1}')
sudo docker start $CONTAINERID
