#!/bin/bash

# Setup Hostname
sudo hostnamectl set-hostname "sonarqube.cloudbinary.io"

# Configure Hostname unto hosts file
echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts

# Update the Repository
sudo apt-get update

# Install required utility softwares
sudo apt-get install git wget unzip zip curl tree -y

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

# Download Sonarqube Image from hub.docker.com
sudo docker pull sonarqube

# display docker images
sudo docker images

# Create docker volumes
docker volume create sonarqube-conf
docker volume create sonarqube-data
docker volume create sonarqube-logs
docker volume create sonarqube-extensions

# Checking docker volumes
#docker volume inspect sonarqube-conf
#docker volume inspect sonarqube-data
#docker volume inspect sonarqube-logs
#docker volume inspect sonarqube-extensions

# Linking docker volumes
sudo mkdir /sonarqube
ln -s /var/lib/docker/volumes/sonarqube-conf/_data /sonarqube/conf
ln -s /var/lib/docker/volumes/sonarqube-data/_data /sonarqube/data
ln -s /var/lib/docker/volumes/sonarqube-logs/_data /sonarqube/logs
ln -s /var/lib/docker/volumes/sonarqube-extensions/_data /sonarqube/extensions

# Create Sonarqube container
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 -v sonarqube-conf:/sonarqube/conf -v sonarqube-data:/sonarqube/data -v sonarqube-logs:/sonarqube/logs -v sonarqube-extensions:/sonarqube/extensions sonarqube