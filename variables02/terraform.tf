# In this terraform file used to working on variable
# here we pass two type variable one is bool type andother one is string type for the different use cases 


provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
}

resource "aws_instance" "myec2" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = var.instance_type
  count                       = 2
  associate_public_ip_address = var.enable_public_ip
  tags = {
    Name = "My-instance-1"
  }
}

variable "enable_public_ip" {
  description = "Enable public IP address"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "instance type t2.micro"
  type        = string
  default     = "t2.micro"
}