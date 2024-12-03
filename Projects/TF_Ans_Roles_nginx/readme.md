provisioning AWS EC2 instances using Terraform and configuring them with Ansible to install Nginx. 

---

## **Ansible Provisioning via Terraform**

This guide covers deploying EC2 instances on AWS and provisioning them with Nginx using Terraform and Ansible. The setup supports both single and multiple instances.

### **Prerequisites**
1. A Linux system with **Terraform**, **Ansible**, and **AWS CLI** installed.
2. AWS credentials configured via `aws configure`.
3. SSH key pair created in AWS and available locally (e.g., `ansible1.pem`).

---

### **Steps**

#### **Step 1: Create AWS Key Pair**
1. In the AWS Management Console, create a key pair named `ansible1`.
2. Download the `.pem` file to your local machine (e.g., `~/Downloads/ansible1.pem`).
3. Set appropriate permissions:
   ```bash
   chmod 400 ~/Downloads/ansible1.pem
   ```

---

#### **Step 2: Create Ansible Playbook**
1. Create a playbook `nginx.yml` to configure Nginx using roles:
   ```yaml
   ---
   - name: Install Nginx
     hosts: all
     remote_user: ubuntu
     become: yes
     roles:
       - nginx
   ```

2. Create the role directory structure:
   ```bash
   mkdir -p roles/nginx/tasks
   ```

3. Define tasks for the Nginx role in `roles/nginx/tasks/main.yml`:
   ```yaml
   ---
   - name: Install Nginx
     apt:
       name: nginx
       state: latest

   - name: Ensure Nginx is running
     systemd:
       name: nginx
       state: started
   ```

---

#### **Step 3: Configure Terraform**
1. Create a `main.tf` file to define resources and provision EC2 instances.

**Variables and Provider Configuration**
```hcl
locals {
  ssh_user         = "ubuntu"
  key_name         = "ansible1"
  private_key_path = "~/Downloads/ansible1.pem"
}

provider "aws" {
  region = "us-east-1"
}
```

**Security Group**
```hcl
resource "aws_security_group" "nginx_sg" {
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
```

**Single EC2 Instance**
```hcl
resource "aws_instance" "nginx" {
  ami                         = "ami-0c7217cdde317cfec"
  subnet_id                   = "subnet-0b102238e4cbdda46"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true
  key_name                    = local.key_name

  tags = {
    Name = "Nginx-Machine"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Waiting for SSH access...'"]

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

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}
```

**Multiple Instances**
Use the `count` meta-argument to create multiple instances:
```hcl
resource "aws_instance" "nginx" {
  count                       = 3
  ami                         = "ami-0c7217cdde317cfec"
  subnet_id                   = "subnet-0b102238e4cbdda46"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true
  key_name                    = local.key_name

  tags = {
    Name = "Nginx-Machine-${count.index + 1}"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Waiting for SSH access...'"]

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
```

---

#### **Step 4: Configure Ansible**
Create an `ansible.cfg` file:
```ini
[defaults]
host_key_checking = False
```

---

#### **Step 5: Deploy with Terraform**
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Review the plan:
   ```bash
   terraform plan
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```

---

### **Key Features**
- **Reusable Playbook**: The Ansible playbook uses roles, making it modular and scalable.
- **Dynamic IP Handling**: Terraform outputs public IPs for use with Ansible.
- **Multiple Instances**: Easily scale EC2 instances with `count`.
- **Seamless Integration**: Terraform provisions instances, while Ansible handles software setup.

This approach ensures efficient infrastructure provisioning and configuration management, leveraging Terraform and Ansible's strengths.


### Below code is for using Local variables 
```hcl
locals {
  aws_region          = "us-east-1"
  ssh_user            = "ubuntu"
  key_name            = "ansible1"
  private_key_path    = "/home/vagrant/ansible1.pem" # make sure download pem file in to local machine 
  ami_id              = "ami-0866a3c8686eaeeba"
  subnet_id           = "subnet-04e893b17598ecbce"
  instance_type       = "t2.micro"
  security_group_name = "nginx_access"
  tags = {
    Name = "Nginx-Machine"
  }
}

# **Provider Configuration**
provider "aws" {
  region = local.aws_region
}

# **Security Group Resource**
resource "aws_security_group" "nginx_sg" {
  name = local.security_group_name

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

# **EC2 Instance Resource**
resource "aws_instance" "nginx" {
  ami                         = local.ami_id
  subnet_id                   = local.subnet_id
  instance_type               = local.instance_type
  security_groups             = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true
  key_name                    = local.key_name

  tags = local.tags

  # **Remote-Exec Provisioner**
  provisioner "remote-exec" {
    inline = [
      "echo 'Wait until SSH is ready'"
    ]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = self.public_ip
    }
  }

  # **Local-Exec Provisioner**
  provisioner "local-exec" {
    command = <<-EOT
      export ANSIBLE_HOST_KEY_CHECKING=False
      ansible-playbook -i ${self.public_ip}, --private-key ${local.private_key_path} nginx.yml
    EOT
  }
}

# **Output Block**
output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}
```
