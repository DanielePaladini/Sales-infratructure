#! /bin/bash

sudo yum update -y
sudo yum upgrade -y

sudo yum install java-1.8.0-openjdk -y

################ CodeDeploy Agent install
sudo yum install ruby -y
sudo yum install wget -y

wget https://aws-codedeploy-eu-west-1.s3.amazonaws.com/latest/install
chmod +x ./install

sudo ./install auto

sudo service codedeploy-agent start

sudo rm ./install