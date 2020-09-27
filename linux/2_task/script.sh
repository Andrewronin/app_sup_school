#! /bin/bash
echo -e " \e[35m ===== 1. Install Jenkins ===== \e[0m"

sudo yum install java-1.8.0-openjdk-devel -y &>/dev/null
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo &>/dev/null
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key &>/dev/null
sudo yum install jenkins -y --nogpgcheck &>/dev/null
sudo systemctl start jenkins
sudo systemctl enable jenkins

echo -e " \e[35m ===== 2. Install Nginx ===== \e[0m"

sudo yum install epel-release -y &>/dev/null
sudo yum install nginx -y &>/dev/null
sudo cp /vagrant/jenkins.conf /etc/nginx/conf.d/jenkins.conf
sudo setenforce 0
sudo sed -e '/listen/ s/^#*/#/' -i /etc/nginx/nginx.conf

echo -e " \e[35m ===== 3. Create certificate ===== \e[0m"

sudo mkdir /etc/nginx/ssl /var/log/nginx/jenkins
sudo openssl genrsa -des3 -passout pass:password -out localhost.key 2048 -noout
sudo openssl rsa -in localhost.key -passin pass:password -out localhost.key
sudo openssl req -x509 \
        -key localhost.key \
        -days 365 \
        -passin pass:password \
        -out localhost.crt \
        -subj "/C=BY/ST=Minsk/L=Minsk/O=project/OU=DevOps/CN=localhost/emailAddress=apavarnitsyn@gmail.com"
sudo mv localhost.key /etc/nginx/ssl/
sudo mv localhost.crt /etc/nginx/ssl/

sudo systemctl start nginx
sudo systemctl enable nginx

echo -e " \e[35m Root password for Jenkins access: " $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword) "\e[0m"

echo -e " \e[35m ===== HTTP request ===== \e[0m"
curl -s -I 'http://localhost'
echo -e " \e[35m ===== HTTPS request ===== \e[0m"
curl -s -I -k 'https://localhost' 
