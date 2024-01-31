provider "aws" {
  region  = "us-east-1"
  access_key = "AKIA2LW3XXCQ4YC4X36W"
  secret_key = "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"
}

# Dynamic Block Implement

locals {
  ingress_rules = [
    {
      port        = 443
      description = "Ingress rule for https"

    },
    {
      port        = 22
      description = "Ingress rule for ssh"
    }
  ]
}

# Respources block 

resource "aws_instance" "myec2" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.main.id]
}

resource "aws_security_group" "main" {
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
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}