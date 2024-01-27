#!/bin/bash
sudo apt-get update -y
sudo hostnamectl set-hostname QA-server
sudo apt-get install tomcat9 -y
sudo apt-get install tomcat9-admin