#! /bin/bash
set -e
sudo setenforce 0

sudo yum install httpd-devel gcc -y &>/dev/null

curl -s https://mirror.datacenter.by/pub/apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.48-src.tar.gz \
     -o tomcat-connectors-1.2.48-src.tar.gz
tar -xvzf tomcat-connectors-1.2.48-src.tar.gz
cd tomcat-connectors-1.2.48-src/native/
./configure --with-apxs=/usr/bin/apxs
sudo make && sudo make install

sudo cp /vagrant/web/mod_jk.conf       /etc/httpd/conf.d/mod_jk.conf
sudo cp /vagrant/web/workers.properties /etc/httpd/conf/workers.properties

sudo systemctl start httpd

curl localhost/sample/