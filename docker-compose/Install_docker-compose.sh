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
sudo apt-get update
# Install Docker Compose on Ubuntu Server
sudo apt-get install docker-compose -y 
sudo apt-get update
# Enable Docker For Ubuntu User
sudo usermod -aG docker ubuntu

# Grant Access Docker Socket
sudo chmod 777 /var/run/docker.sock

# Enable Docker Services at boot level
sudo systemctl enable docker

# Restart Docker Daemon 
sudo systemctl restart docker
# Switching to ubuntu user
sudo su - ubuntu
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
sudo chown -R $USER:$USER cloudops *
# Backup settings.py file
sudo cp /opt/cloudops/settings.py "/opt/cloudops/settings.py_$(date +%F_%R)"
# adding configuration 
sudo sed -i '/from pathlib import Path/a import os' /opt/cloudops/settings.py
sudo sed -i "29a ALLOWED_HOSTS = ['*']" /opt/cloudops/settings.py
sudo sed -i "81a 'PORT': 5432," /opt/cloudops/settings.py
sudo sed -i "81a 'HOST': 'db'," /opt/cloudops/settings.py
sudo sed -i "81a 'PASSWORD': os.environ.get('POSTGRES_PASSWORD')," /opt/cloudops/settings.py
sudo sed -i "81a 'USER': os.environ.get('POSTGRES_USER')," /opt/cloudops/settings.py
sudo sed -i "81a 'NAME': os.environ.get('POSTGRES_NAME')," /opt/cloudops/settings.py
sudo sed -i "81a 'ENGINE': 'django.db.backends.postgresql'," /opt/cloudops/settings.py
# deleting line
sudo sed -i '29d' /opt/cloudops/settings.py
sudo sed -i '79,80d' /opt/cloudops/settings.py

# Bulid docker compose
sudo docker-compose up
