#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install ansible -y
sudo apt-get install default-jre -y
ansible-galaxy install robertdebock.bootstrap
ansible-galaxy install robertdebock.java
ansible-galaxy install robertdebock.service
ansible-galaxy install robertdebock.tomcat
