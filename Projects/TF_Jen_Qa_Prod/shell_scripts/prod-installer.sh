#!/bin/bash
sudo apt-get update -y
sudo hostnamectl set-hostname Prod-server
sudo apt-get install tomcat9 -y
sudo apt-get install tomcat9-admin