# Download Base Image from hub.docker.com
FROM ubuntu

# Execute Commands
RUN apt-get update 

# Environment Variables
ENV TZ=Asia/Kolkata  

# Update Environment Variable unto File 
RUN echo $TZ > /etc/timezone 

# Download, Install & Configure 
RUN apt-get update 
RUN apt-get install openjdk-17-jdk -y 
RUN apt-get install wget -y 
RUN apt-get install curl -y 
RUN apt-get install unzip -y 

# Environment Variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Update Environment Variable unto File 
RUN echo $JAVA_HOME >> /etc/environment

# Cleanup APT Command 
RUN apt-get clean 

RUN mkdir /opt/tomcat/

WORKDIR /opt/
RUN curl -O https://downloads.apache.org/tomcat/tomcat-11/v11.0.2/bin/apache-tomcat-11.0.2.tar.gz
RUN cd /opt/ && tar -xzf apache-tomcat-11.0.2.tar.gz && rm apache-tomcat-11.0.2.tar.gz
RUN pwd
#RUN apache-tomcat-11.0.2.tar.gz /opt/tomcat/
RUN mv apache-tomcat-11.0.2/* /opt/tomcat/.
RUN ls -lrta /opt/tomcat/conf/tomcat-users.xml


# Take Tomcat Configuration as backup 
RUN cp /opt/tomcat/conf/tomcat-users.xml "/opt/tomcat/conf/tomcat-users.xml_$(date +%F_%R)"

# To delete last line and which contains </tomcat-users>
RUN sed -i '$d' /opt/tomcat/conf/tomcat-users.xml

#Add User & Attach Roles to Tomcat 
RUN echo '<role rolename="manager-gui"/>'  >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="manager-jmx"/>'    >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="admin-gui"/>'     >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<user username="admin" password="redhat@123" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo "</tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml

RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /opt/tomcat/webapps/manager/META-INF/context.xml 
RUN echo '<Context antiResourceLocking="false" privileged="true" >' >> /opt/tomcat/webapps/manager/META-INF/context.xml 
RUN echo '</Context>' >> /opt/tomcat/webapps/manager/META-INF/context.xml 

RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /opt/tomcat/webapps/host-manager/META-INF/context.xml 
RUN echo '<Context antiResourceLocking="false" privileged="true" >' >> /opt/tomcat/webapps/host-manager/META-INF/context.xml 
RUN echo '</Context>' >> /opt/tomcat/webapps/host-manager/META-INF/context.xml 

#COPY ./devops.war /opt/tomcat/webapps/
WORKDIR /opt/tomcat/webapps
RUN curl -O -L https://github.com/satheeshr03/Terraform/tree/main/files/devops.war

RUN echo '[Unit]' > /etc/systemd/system/tomcat.service 
RUN echo 'Description=Apache Tomcat Web Application Container' >> /etc/systemd/system/tomcat.service 
RUN echo 'After=network.target' >> /etc/systemd/system/tomcat.service 

RUN echo '[Service]' >> /etc/systemd/system/tomcat.service 
RUN echo 'Type=forking' >> /etc/systemd/system/tomcat.service 

RUN echo 'Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64' >> /etc/systemd/system/tomcat.service 
RUN echo 'Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid' >> /etc/systemd/system/tomcat.service  
RUN echo 'Environment=CATALINA_HOME=/opt/tomcat' >> /etc/systemd/system/tomcat.service 
RUN echo 'Environment=CATALINA_BASE=/opt/tomcat' >> /etc/systemd/system/tomcat.service 
RUN echo 'Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'' >> /etc/systemd/system/tomcat.service 
RUN echo 'Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'' >> /etc/systemd/system/tomcat.service 

RUN echo 'ExecStart=/opt/tomcat/bin/startup.sh' >> /etc/systemd/system/tomcat.service 
RUN echo 'ExecStop=/opt/tomcat/bin/shutdown.sh' >> /etc/systemd/system/tomcat.service 

RUN echo 'User=root' >> /etc/systemd/system/tomcat.service 
RUN echo 'Group=root' >> /etc/systemd/system/tomcat.service 
RUN echo 'UMask=0007' >> /etc/systemd/system/tomcat.service 
RUN echo 'RestartSec=10' >> /etc/systemd/system/tomcat.service 
RUN echo 'Restart=always' >> /etc/systemd/system/tomcat.service 

RUN echo '[Install]' >> /etc/systemd/system/tomcat.service 
RUN echo 'WantedBy=multi-user.target' >> /etc/systemd/system/tomcat.service 

RUN sed -i 's/port="8080"/port="80"/' /opt/tomcat/conf/server.xml
# Enable WebServer Port i.e. HTTP 80/TCP
EXPOSE 80

# Execute WebServer
CMD ["/opt/tomcat/bin/catalina.sh", "run"]