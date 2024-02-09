Tomcat server setup using Ansibe with Terraform 
-----------------------------------------------------
 1. Server Provisioning 
 2. Software Installation
 3. Configuration Management 
 4. Continuos Deployment 

 - Provison Ec2 machine and install software in it using ansible from local machine 

 - create EC2 machine 
 - create security group and whitelist the port 22 and 8080
 - fetch the public ip 
 - Run An sible Playbook 
 	- Install java, tomcat for web server
 	- Configure Tomcat 
 	- Deploy Application 

 step1: create a Folder for workspace 
  - mkdir tomcatSetupAnsibleTerraform
  - cd tomcatSetupAnsibleTerraform

 step2: creat a provider file 
  - vim provider.tf
  ----------------------
	terraform {
	  required_providers {
	    aws = {
	      source  = "hashicorp/aws"
	      version = "4.11.0"
	    }
	  }
	}

	provider "aws" {
	  region     = "ap-south-1"
	}
	--------------------------

 step3: create ec2.tf file for terraform code 
  - vim ec2.tf
    -------------------------
	resource "aws_instance" "myec2" {
	  ami                    = "ami-08df646e18b182346"
	  instance_type          = "t2.micro"
	  availability_zone = "ap-south-1a"
	  vpc_security_group_ids = [aws_security_group.allow_tls.id]
	  key_name = "pswain"

	  tags = {
	    name = "testec2"
	  }

	  provisioner "local-exec" {
	    command = "echo ${aws_instance.myec2.public_ip} >> /etc/ansible/hosts"
	  }
	}
	-------------------------------

 step4: create sg.tf file for inbound and outbound access
   
   - vim sg.tf
	   ---------------------------------
		//Security group creation and whitelisting the ip
		resource "aws_security_group" "allow_tls" {
		  name = "terraform-sg"

		  ingress {
		    description = "Allow port 22 - inbound"
		    from_port   = 22
		    to_port     = 22
		    protocol    = "tcp"
		    cidr_blocks = ["0.0.0.0/0"]
		  }
		  ingress {
		    description = "Allow port 8080 - inbound"
		    from_port   = 8080
		    to_port     = 8080
		    protocol    = "tcp"
		    cidr_blocks = ["0.0.0.0/0"]
		  }

		  egress {
		    description = "outbound"
		    from_port   = 0
		    to_port     = 0
		    protocol    = "-1"
		    cidr_blocks = ["0.0.0.0/0"]
		  }
		}
		--------------------------------------------
 
 step5: create Ansible Playbook for setup tomcat server
   
   - vim setup_tomcat.yml
   -------------------------------------
	 ---
	 - hosts: all
	   become: true
	   tasks:
	     - name: Install Java
	       yum:
	         name: java-1.8.0-openjdk
	         state: present

	     - name: add group "tomcat"
	       group: name=tomcat

	     - name: add user "tomcat"
	       user: name=tomcat group=tomcat home=/usr/share/tomcat createhome=no
	       become: True
	       become_method: sudo

	     - name: Download Tomcat
	       get_url: url=http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz dest=/opt/apache-tomcat-7.0.61.tar.gz

	     - name: Extract archive
	       command: chdir=/usr/share /bin/tar xvf /opt/apache-tomcat-7.0.61.tar.gz -C /opt/ creates=/opt/apache-tomcat-7.0.61

	     - name: Symlink install directory
	       file: src=/opt/apache-tomcat-7.0.61 path=/usr/share/tomcat state=link

	     - name: Change ownership of Tomcat installation
	       file: path=/usr/share/tomcat/ owner=tomcat group=tomcat state=directory recurse=yes

	     - name: Copy file
	       copy: src=target/LoginWebApp.war dest=/usr/share/tomcat/webapps/LoginWebApp.war

	     - name: Allow all access to tcp port 8080
	       ufw:
	         rule: allow
	         port: '8080'
	         proto: tcp

	     - name: Start Tomcat
	       command: /usr/share/tomcat/bin/startup.sh
	       become: yes
	       become_user: root
	--------------------------------------------

 step6: Now perform terraform commands 
 	- terraform init 
 	- terraform plan 
 	- terraform apply 

 step7: Take public ip of server perform below commands
  - ssh -i <path_of_pemfile> ec2-user@<public_ip_sever>
 
 step8: Take PublicKey file copy and paste into remote server paste in the .ssh/authoried_keys file Now it establish passwordless connection from local machine to remote machine  
  - ansible -m ping all
  	- above command make sure success of ping and pong 

 step9: Now excute playbook here in local machine 
  - ansible-playbook setup_tomcat.yml 





