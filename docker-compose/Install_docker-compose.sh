#!/bin/bash

# Setup Hostname 
hostnamectl set-hostname "docker-compose.sathi.io"

# Configure Hostname unto hosts file 
echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts 

# Update the Ubuntu Local Repository with Online Repository 
sudo apt-get update 

# Download, Install & Configure Utility Softwares 
sudo apt-get install git curl unzip tree wget -y 

# Install Docker on Ubuntu Server
sudo apt-get install docker.io -y 

# Install Docker Compose on Ubuntu Server
sudo apt-get install docker-compose -y 

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
sudo wget https://raw.githubusercontent.com/satheeshr240/Terraform/main/docker-compose/files/Dockerfile

# Downloading the Requirements.txt file from Git
sudo wget https://raw.githubusercontent.com/satheeshr240/Terraform/main/docker-compose/files/requirements.txt

# Downloading the docker-compose.yml file from Git
sudo wget https://raw.githubusercontent.com/satheeshr240/Terraform/main/docker-compose/files/docker-compose.yml

# Create a Django project
sudo docker-compose run web django-admin startproject cloudops .
# Change the User & Group Permissions
sudo su - ubuntu
sudo chown -R $USER:$USER cloudops *
