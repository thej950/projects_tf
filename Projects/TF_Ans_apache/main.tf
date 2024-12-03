locals {
  pemfile          = "aws_key"
  public_key       = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFl7N5bvacOplJVj/b16qKy7Jv5ki2kK4FW7L3k0Bszh"
  ubuntu_id        = "ami-0c7217cdde317cfec"
  machine_size     = "t2.micro"
  private_key      = "./sshkeys/aws_key"
  apache_yaml_file = "./apache.yml"
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_key_pair" "mykey" {
  key_name   = local.pemfile
  public_key = local.public_key
}
resource "aws_security_group" "apache-sg" {
  name = "apache_sg_access"

  ingress {
    description = "open ports 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "open ports 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "open all rules for outside"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "apache-server" {
  ami                    = local.ubuntu_id
  instance_type          = local.machine_size
  vpc_security_group_ids = [aws_security_group.apache-sg.id]
  key_name               = local.pemfile

  tags = {
    Name = "MyTerraformMachine"
  }

  provisioner "remote-exec" {
    inline = ["cat /etc/os-release"]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.apache-server.public_ip
    private_key = file(local.private_key)
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i 'ubuntu@${aws_instance.apache-server.public_ip},' ${local.apache_yaml_file} --private-key ${local.private_key}"
  }
}
