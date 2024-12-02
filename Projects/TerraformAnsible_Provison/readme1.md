# this code is for local variables
```
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

