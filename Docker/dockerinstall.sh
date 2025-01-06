#!/bin/bash

# Setup Hostname 
hostnamectl set-hostname "docker.sathi.io"

# Configure Hostname unto hosts file 
echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts 

# Update the Ubuntu Local Repository with Online Repository 
sudo apt-get update 

# Download, Install & Configure Utility Softwares 
sudo apt-get install git curl unzip tree wget -y 

# Install Docker on Ubuntu Server
sudo apt-get install docker.io -y 

# Enable Docker For Ubuntu User
sudo usermod -aG docker ubuntu

# Grant Access Docker Socket
sudo chmod 777 /var/run/docker.sock

# Enable Docker Services at boot level
sudo systemctl enable docker

# Restart Docker Daemon 
sudo systemctl restart docker
cd /opt/
# Downloading the Dockerfile from Git
sudo wget https://raw.githubusercontent.com/satheeshr240/Terraform/main/files/Dockerfile

# Build the Tomcat Image
sudo docker build .
sudo sleep 10
# Validate the Tomcat Image and assign the images id to Variable
IMG=$(sudo docker images | grep none | awk '{print $3}')
sudo echo $IMG

# Assign Tag to Tomcat Docker Image
sudo docker tag $IMG tomcat:1.0.0

# Execute/Run a Tomcat Container
sudo docker run -d --name appserver -p 80:80 $IMG
