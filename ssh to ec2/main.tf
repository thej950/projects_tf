provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
}

resource "aws_instance" "myec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  key_name               = "aws-key"
  vpc_security_group_ids = [aws_security_group.main-sg.id]
  tags = {
    Name = "My-instance"
  }
}

resource "aws_security_group" "main-sg" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
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

resource "aws_key_pair" "myec2key" {
  key_name   = "aws-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUUsOUa315grnZ0cHqct8qGIA0nDcn0NTl4h39Miwm9wfot4YnGVAFChnpBvPHA/iftkyq9QKDb1YoNNL0Xxcs6bplQTloXj4MvvJB+x7pe1dLhFzlIzdBUvJZZNxkh3NujUZZ1PAy6yjDK2SAMXtm4R1FGK5zGW4rFcoPwUwYd3uHLiTb40mcY8oA1qpIDn8D/tERVUpS86DCCEN4X6Xzagst8VutfH4g3Sr8aU4W7hpdaO/dwxiSaS0gik7YdSbxiVY9qjHQucTD521sHUJelf6olw6WEpP1yLHjOgcDgpjlbY8ICmonV7Jjj4Az4IKgmk0+fWNDjzAQMmqF6H/h7n6l3pwJnKjPxs1Odt2uPuCr7EZ82higSD+uBQtAVfvt7Xs9jJuc/l0u+g8DB2wmLmgtvD7oRe5tLXxJICkDyEs3obyfWj1b/sTU1NfE582U5yH6lr9PHkemdimE6tZdehhJzvvjJUkFTeqDzYk2ip0VDPiOIYkS2h5wEMEV+6U= DELL@Navathej"
}