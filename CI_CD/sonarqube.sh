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

# Download a docker images of Sonarqube from hub.docker.com
sudo docker pull sonarqube

# check Downloaded Docker Images of Sonarqube
sudo docker images

# Create docker volumes to store the Sonarqube persistent data
docker volume create sonarqube-conf
docker volume create sonarqube-data
docker volume create sonarqube-logs
docker volume create sonarqube-extensions

# Verify the persistent data directories
#docker volume inspect sonarqube-conf
#docker volume inspect sonarqube-data
#docker volume inspect sonarqube-logs
#docker volume inspect sonarqube-extensions

# create directory  
sudo mkdir /sonarqube
# Optionally, create symbolic links to an easier access location 
ln -s /var/lib/docker/volumes/sonarqube-conf/_data /sonarqube/conf
ln -s /var/lib/docker/volumes/sonarqube-data/_data /sonarqube/data
ln -s /var/lib/docker/volumes/sonarqube-logs/_data /sonarqube/logs
ln -s /var/lib/docker/volumes/sonarqube-extensions/_data /sonarqube/extensions

# Start a Sonarqube container with persistent data storage 
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 -v sonarqube-conf:/sonarqube/conf -v sonarqube-data:/sonarqube/data -v sonarqube-logs:/sonarqube/logs -v sonarqube-extensions:/sonarqube/extensions sonarqube