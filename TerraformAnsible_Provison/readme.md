Ansible Provision By Terraform 
-------------------------------
- This Need To Implement on Linux machine
- Install ansible and terraform and awscli tool in Local machine where this need to perform 
- Here we setup machine with nginx installation on that using Ansible roles 

Terraform ansible provision
----------------------------
## STEP1: CRAETE KEYPAIR IN AWS AND DOWNLOAD IN TO LOCAL MACHINE "ansible1"

## STEP2: CREATE A yaml FILE FOR RUNNING A ROLE
 - vim nginx.yml

        ---
        - name: Install Nginx
          hosts: all
          remote_ user: ubuntu
          become:  yes
        
          roles:
           - nginx
    
## STEP3: NOW CREATE ROLES FOLDER UNDER ROLES CREATE NGINX FOLDER AFTER CREATE TASKS FOLDER UNDER TASKS FOLDER CREATE MAIN.YML FILE TO INCLUDE TASKS FOR NGINX TO INSTALL 

 - mkdir -p roles/nginx/tasks
 - vim roles/nginx/tasks/main.yml

        ---
        - name: Ensure Nginx install with latest only
          apt: 
            name: nginx
            state: latest
        - name: Make sure Nginx is Running
          systemd:
            name: nginx
            state: started


## STEP4: CREATE MAIN.TF FILE in current workspace location
 - vim main.tf

        locals {
            ssh_user         = "ubuntu"
            key_name         = "ansible1"
            private_key_path = "~/Downloads/ansible1.pem"
        }

        provider "aws" {
            region = "us-east-1"
        }

        resource "aws_security_group" "nginx-sg" {
            name = "nginx_access"

            ingress {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
            ingress {
                from_port   = 80
                to_port     = 80
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
            egress {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
            }
        }

        resource "aws_instance" "nginx" {
            ami                         = "ami-0c7217cdde317cfec"
            subnet_id                   = "subnet-0b102238e4cbdda46"
            instance_type               = "t2.micro"
            security_groups             = [aws_security_group.nginx-sg.id]
            associate_public_ip_address = true
            key_name                    = local.key_name

            tags = {
                Name = "Nginx-Machine"
            }

            provisioner "remote-exec" {
                inline = ["echo 'wait untill ssh is ready'"]

                connection {
                type        = "ssh"
                user        = local.ssh_user
                private_key = file(local.private_key_path)
                host        = aws_instance.nginx.public_ip
                }
            }
            provisioner "local-exec" {
                command = <<-EOT
                export ANSIBLE_HOST_KEY_CHECKING=False
                ansible-playbook -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yml
                EOT
            }
        }

        output "nginx_ip" {
            value = "aws_instance.nginx.public_ip"
        }

## STEP5: CREATE ANSIBLE CONFIG FILE 
 - vim ansible.cfg 
    
        [defaults]
        host_key_checking = False

## STEP6: EXCUTE TERRAFORM COMMANDS
 - terraform init 
 - terraform plan 
 - terraform apply 



# below Code for multiple machines to create 

        locals {
            ssh_user         = "ubuntu"
            key_name         = "ansible1"
            private_key_path = "~/Downloads/ansible1.pem"
        }

        provider "aws" {
            region = "us-east-1"
        }

        resource "aws_security_group" "nginx-sg" {
            name = "nginx_access"

            ingress {
                from_port   = 22
                to_port     = 22
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
            ingress {
                from_port   = 80
                to_port     = 80
                protocol    = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
            }
            egress {
                from_port   = 0
                to_port     = 0
                protocol    = "-1"
                cidr_blocks = ["0.0.0.0/0"]
            }
        }

        resource "aws_instance" "nginx" {
            count                       = 3
            ami                         = "ami-0c7217cdde317cfec"
            subnet_id                   = "subnet-0b102238e4cbdda46"
            instance_type               = "t2.micro"
            security_groups             = [aws_security_group.nginx-sg.id]
            associate_public_ip_address = true
            key_name                    = local.key_name

            tags = {
                Name = "Nginx-Machine-${count.index + 1}"
            }

            provisioner "remote-exec" {
                inline = ["echo 'wait until ssh is ready'"]

                connection {
                type        = "ssh"
                user        = local.ssh_user
                private_key = file(local.private_key_path)
                host        = self.public_ip
                }
            }

            provisioner "local-exec" {
                command = <<-EOT
                export ANSIBLE_HOST_KEY_CHECKING=False
                ansible-playbook -i ${self.public_ip}, --private-key ${local.private_key_path} nginx.yml
                EOT
            }
        }

        output "nginx_ips" {
            value = aws_instance.nginx[*].public_ip
        }
