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
