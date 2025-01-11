#!/bin/bash
 # Setup Hostname
sudo hostnamectl set-hostname "jenkins.cloudbinary.io"

 # Update the hostname part of Host File
echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts

# Update Ubuntu Repository
sudo apt-get update

# Download, & Install Utility Softwares
sudo apt-get install git wget unzip curl tree -y

# Download, Install Java 22
sudo apt-get install openjdk-22-jdk -y

# Backup the Environment File
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"

# Create Environment Variables
echo "JAVA_HOME=/usr/lib/jvm/java-22-openjdk-amd64/" >> /etc/environment

# Download, Install Maven 
sudo apt-get install maven -y

# Backup the Environment File
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"

# Create Environment Variables
echo "MAVEN_HOME=/usr/share/maven" >> /etc/environment

# Compile the Configuration
source /etc/environment

# Add Jenkins repository key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository to apt sources
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update apt and install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
sudo systemctl enable jenkins