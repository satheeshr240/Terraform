#!/bin/bash

# Setup Hostname
sudo hostnamectl set-hostname "jfrog.cloudbinary.io"

# Configure Hostname unto hosts file
echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts

# Update the Repository 
sudo apt-get update

# Install required utility softwares
sudo apt-get install vim curl elinks unzip wget tree git -y

# Download, Install Java 22
sudo apt-get install openjdk-22-jdk -y 

# Backup the Environment File
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"

# Create Environment Variables
echo "JAVA_HOME=/usr/lib/jvm/java-22-openjdk-amd64/" >> /etc/environment 

# Compile the Configuration
source /etc/environment
cd /opt/

# Download JFROG Software 
# sudo wget  https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/[RELEASE]/jfrog-artifactory-oss-[RELEASE]-linux.tar.gz  
sudo wget  https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.9.0/jfrog-artifactory-oss-7.9.0-linux.tar.gz 
sudo wget  https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.98.9/jfrog-artifactory-oss-7.98.9-linux.tar.gz 

 # Extract the Tar File
tar xvzf jfrog-artifactory-oss-7.98.9-linux.tar.gz 

# Rename the Directory 
mv artifactory-oss-* jfrog

# Backup the Environment File
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"

# Create Environment Variables
echo "JFROG_HOME=/opt/jfrog" >> /etc/environment

# To start JFROG Artifactory, Go to Bin 
cd /opt/jfrog/app/bin/ 

# Start JFROG Artifactory
./artifactory.sh status
./artifactory.sh start

# Take the PublicIP of EC2 Instance and Login
# http://<public_ip_of_ec2_instance>:8081

    # Default UserName & Passwords are:
        # UserName : admin ; Password : password

    # Configure INIT Scripts for JFrog Artifactory
    # sudo cd /etc/systemd/system/

    # Downloading the Dockerfile from Git
    # sudo wget https://raw.githubusercontent.com/satheeshr240/Terraform/main/CI_CD/INIT_Scripts_Start/artifactory.service
  
    # Start JFrog Service

    # systemctl daemon-reload
    
    # sudo systemctl status artifactory.service

    # sudo systemctl stop artifactory.service
    
    # sudo systemctl start artifactory.service
    
    # sudo systemctl restart artifactory.service
    
    # sudo systemctl enable artifactory.service 
