provider "aws" {
  region = "us-east-1"
}

locals {
  instance_name = "${terraform.workspace}-instance"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = var.instance_type
  tags = {
    Name = local.instance_name
  }
} 