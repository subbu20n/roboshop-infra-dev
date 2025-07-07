#!/bin/bash 

component=$1
dnf install ansible -y 
ansible-pull -U https://github.com/subbu20n/terraform-aws-roboshop.git -e component=$1 -e env=$2 main.yaml
