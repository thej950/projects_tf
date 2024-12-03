### Setup apache on a Linux instance using Terraform and Ansible.
### Install Required Tools on**Local Machine**
1. **Terraform**: [Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. **Ansible**: [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
3. **AWS CLI**: [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

### **Step 2: Generate SSH Keys**
Run the following command to generate SSH keys:
```bash
ssh-keygen -t ed25519 -f ./sshkeys/aws_key -q -N ""
```
- **`aws_key`** is the key name. 
- Copy the content of the public key (`aws_key.pub`) to use in the Terraform configuration.


1. write main.tf file with local variables 
2. write apache yaml file for installation of apache
3. write ansible.cfg file 
4. generate sshkeys to connect remote machine securly paste public key in locals

        provisioner "local-exec" {
            command = "ansible-playbook -i 'ubuntu@${aws_instance.apache-server.public_ip},' ${local.apache_yaml_file} --private-key ${local.private_key}"
        }

 - above command used to run ansible playbook from local machine to excute on remote machine 


---
### **Step 3: Terraform Configuration**
### **3.1 Local Variables**
The `locals` block simplifies the configuration by defining reusable variables:
```hcl
locals {
  pemfile          = "aws_key"               # Name of the AWS key pair
  public_key       = "ssh-ed25519 AAAAC3..." # Public key for SSH authentication
  ubuntu_id        = "ami-0c7217cdde317cfec" # Ubuntu AMI ID (adjust based on your region)
  machine_size     = "t2.micro"              # Instance type
  private_key      = "./sshkeys/aws_key"     # Path to the private key file
  apache_yaml_file = "./apache.yml"          # Path to the Ansible playbook
}
```

### **3.2 AWS Provider**
Defines the AWS region for the infrastructure:
```hcl
provider "aws" {
  region = "us-east-1"
}
```

---

### **3.3 Key Pair Creation**
The `aws_key_pair` resource creates an SSH key pair on AWS. This is used to access the EC2 instance:
```hcl
resource "aws_key_pair" "mykey" {
  key_name   = local.pemfile        # Name of the key pair
  public_key = local.public_key     # Public key content
}
```

---

### **3.4 Security Group**
Defines the firewall rules to allow incoming SSH (port 22) and HTTP (port 80) traffic:
```hcl
resource "aws_security_group" "apache-sg" {
  name = "apache_sg_access"

  ingress {
    description = "open ports 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from any IP
  }

  ingress {
    description = "open ports 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from any IP
  }

  egress {
    description = "open all rules for outside"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"            # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

### **3.5 EC2 Instance**
Creates the EC2 instance and provisions it with Ansible:
```hcl
resource "aws_instance" "apache-server" {
  ami                    = local.ubuntu_id            # Use the Ubuntu AMI ID
  instance_type          = local.machine_size         # Instance type
  vpc_security_group_ids = [aws_security_group.apache-sg.id] # Attach the security group
  key_name               = local.pemfile              # Assign the key pair for SSH access

  tags = {
    Name = "MyTerraformMachine" # Tag for easier identification
  }
```

#### **Remote Provisioning**
The `remote-exec` provisioner checks the system details:
```hcl
  provisioner "remote-exec" {
    inline = ["cat /etc/os-release"] # Simple command to display the OS
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"                # Default Ubuntu user
    host        = aws_instance.apache-server.public_ip # Dynamic IP of the instance
    private_key = file(local.private_key) # SSH private key for authentication
  }
```

#### **Local Ansible Provisioning**
Runs an Ansible playbook (`apache.yml`) to configure Apache on the instance:
```hcl
  provisioner "local-exec" {
    command = "ansible-playbook -i 'ubuntu@${aws_instance.apache-server.public_ip},' ${local.apache_yaml_file} --private-key ${local.private_key}"
  }
}
```
- The `-i` flag dynamically passes the instance's public IP to Ansible.
- The `--private-key` flag specifies the private key for SSH authentication.

---
### **Step 4: Ansible Playbook**

#### **apache.yml**
This playbook installs and configures Apache on the instance:
```yaml
---
- name: Setup Apache Web Server
  hosts: all
  become: yes

  tasks:
    - name: Ensure Apache is installed
      apt:
        name: apache2
        state: present
        update_cache: yes

    - name: Ensure Apache is running
      systemd:
        name: apache2
        state: started
        enabled: yes
```

### **Step 5: Ansible Configuration**

#### **ansible.cfg**
Create the configuration file to manage Ansible's behavior:
```ini
[defaults]
host_key_checking = False
inventory = ./inventory
```

---
### **Step 6: Execute Terraform**

#### **Commands**
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Validate the configuration:
   ```bash
   terraform validate
   ```
3. Plan the deployment:
   ```bash
   terraform plan
   ```
4. Apply the configuration:
   ```bash
   terraform apply
   ```
   Confirm the changes when prompted.

---


### **6. Key Features**
1. **Reusability**: Using local variables makes the configuration modular and reusable.
2. **Automation**: The instance is provisioned automatically with Apache using Ansible.
3. **Dynamic Configuration**: Terraform dynamically retrieves the instance's public IP for Ansible.
4. **Security**: Security group rules allow controlled access to the instance.

---

### **Verification**
1. Use the public IP from the Terraform output.
2. Access `http://<instance-public-ip>` to verify Apache is running.
3. Ensure the EC2 instance is reachable via SSH:
   ```bash
   ssh -i ./sshkeys/aws_key ubuntu@<instance-public-ip>
   ```
