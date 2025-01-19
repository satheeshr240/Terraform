#!/bin/bash
sudo hostnamectl set-hostname "tomcat.cloudbinary.io"
echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts
sudo apt-get update
sudo apt-get install git wget unzip curl tree -y
sudo apt-get install openjdk-21-jdk -y
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
echo "JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64/" >> /etc/environment
cd /opt/
# sudo wget https://downloads.apache.org/tomcat/tomcat-8/v8.5.96/bin/apache-tomcat-8.5.96.tar.gz
#sudo wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.0-M24/bin/apache-tomcat-11.0.0-M24.tar.gz
sudo wget https://downloads.apache.org/tomcat/tomcat-11/v11.0.2/bin/apache-tomcat-11.0.2.tar.gz
sudo tar xvzf apache-tomcat-11.0.2.tar.gz
sudo mv apache-tomcat-11.0.2/ tomcat
cd /opt/tomcat/
sudo cp -pvr /opt/tomcat/conf/tomcat-users.xml "/opt/tomcat/conf/tomcat-users.xml_$(date +%F_%R)"
sed -i '$d' /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-gui"/>'  >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-jmx"/>'    >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="admin-gui"/>'     >> /opt/tomcat/conf/tomcat-users.xml
echo '<role rolename="admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo '<user username="admin" password="redhat@123" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
echo "</tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml
sudo cp -pvr /opt/tomcat/webapps/manager/META-INF/context.xml "/opt/tomcat/webapps/manager/META-INF/context.xml_$(date +%F_%R)"
sed -i '2,$d' /opt/tomcat/webapps/manager/META-INF/context.xml
echo '<Context antiResourceLocking="false" privileged="true" >' >> /opt/tomcat/webapps/manager/META-INF/context.xml
echo '</Context>' >> /opt/tomcat/webapps/manager/META-INF/context.xml
sudo cp -pvr /opt/tomcat/webapps/host-manager/META-INF/context.xml "/opt/tomcat/webapps/host-manager/META-INF/context.xml_$(date +%F_%R)"
sed -i '2,$d' /opt/tomcat/webapps/host-manager/META-INF/context.xml
echo '<Context antiResourceLocking="false" privileged="true" >' >> /opt/tomcat/webapps/host-manager/META-INF/context.xml
echo '</Context>' >> /opt/tomcat/webapps/host-manager/META-INF/context.xml
cd /etc/systemd/system/
sudo wget https://raw.githubusercontent.com/satheeshr240/Terraform/main/CI_CD/INIT_Scripts_Start/tomcat.service
#cd /opt/tomcat/bin/
#./startup.sh
systemctl enable tomcat
systemctl start tomcat