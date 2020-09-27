#! /bin/bash
set -e
IP_ADDRESS=$(hostname -I | awk '{print $2}')
sudo setenforce 0
sudo yum install java-1.8.0-openjdk unzip -y &>/dev/null

cd /opt/
sudo curl -s https://deac-riga.dl.sourceforge.net/project/jboss/JBoss/JBoss-4.2.3.GA/jboss-4.2.3.GA.zip -o jboss.zip
sudo unzip -q jboss.zip
sudo rm jboss.zip
sudo curl -s https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war -o  /opt/jboss-4.2.3.GA/server/all/deploy/sample.war
sudo /opt/jboss-4.2.3.GA/bin/run.sh -c all -b $IP_ADDRESS </dev/null &>/dev/null &