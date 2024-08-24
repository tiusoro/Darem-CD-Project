#!/bin/bash

# Install Epel
sudo amazon-linux-extras install epel -y

# Install Git
sudo yum install git -y

# Install Java       # ===> Google: download java 17 for amazon linux
sudo yum install java-17-amazon-corretto-headless -y  

# Install Maven      # ===> Google: index of maven
cd opt/						       
wget https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
sudo tar xvf apache-maven-3.9.6-bin.tar.gz

# Install Docker
cd ..
sudo yum install docker -y

# Start and Enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Install Jenkins     # ===> Google: jenkins linux rpm
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  
# Confirm Repo ==> cd /etc/yum.repos.d/  ==>  ll ==> cat jenkins.repo
sudo yum install jenkins -y

# Start and Enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Ensure port: 8080 is enabled in the sg

# Reload the bash profile
. ~/.bash_profile

