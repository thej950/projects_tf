provider "aws" {
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
  region     = "us-east-1"
}

resource "aws_instance" "my-ec2" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  tags = {
    Name = "my-instance"
  }
}