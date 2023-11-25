provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  tags          = var.project_environment
}


variable "project_environment" {
  description = "project name and environment"
  type        = map(string)
  default = {
    "project"   = "project-alpha"
    environment = "dev"
  }
}