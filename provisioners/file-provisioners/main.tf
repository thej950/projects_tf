provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
}

resource "aws_instance" "myec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  key_name               = "aws-key1"
  vpc_security_group_ids = [aws_security_group.main-sg1.id]
  tags = {
    Name = "My-instance"
  }
  provisioner "file" {
    source      = "./test/test-file"
    destination = "/home/ubuntu/test-file"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("C:\\Users\\DELL\\Desktop\\terraform-work\\provisioners\\file-provisioners\\sshkeys\\aws-key1")
    timeout     = "4m"
  }
}

resource "aws_security_group" "main-sg1" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

resource "aws_key_pair" "mykey" {
  key_name   = "aws-key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZE+e256IwqDbEM3twL11NshNd4XLFZzoLZ6hzYUUB0i6YGmnqAk+KizZUj+hECRNnX21+ZxdppMN+TKfhOEB0X3jyo8FQAqyL/b3Fq2lTkXOCmCz2iWyESR1z6kbJvTePqXm+q59/7yoQcTd/D4DP/Onk0Qtb52B+Z760LqpLSwyEq6WD3wQq0KDwaVfZ3Ppgm5LpdBg1M0kWBBndIum5Jrt8do6KsNokZ7tN+jOQWF1/9h+N27NQtoWWn+bTwhS4YfIkNxr44zxWNc9CUD5UsTff6Ve7tUwMnsBBErC/SPejldQTEP+cPSAEmhkJrAMohs1yGfK5bbn0/xbB/i30Y2R2/RLJbZEkuHqlIgsbDOW43XdAdic1Um2MG96iopdvZ5DGNZsB8Z+rr5JHSyxnf7ulK1S5mR9lqii0ZTl+3JuD36n1kbCgoz/fVJWpUpo+TT5Go6B5N8ApwuEuyN4/WJnSv9JOfxt2QtKbJGTSqJXkZbkHUYgJgz56mc5HYX8= DELL@Navathej"
}