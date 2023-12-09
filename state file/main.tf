
terraform {
  backend "s3" {
    bucket = "thej-bucket"
    key    = "key/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my-ec2" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  tags = {
    Name = "my-instance"
  }
}