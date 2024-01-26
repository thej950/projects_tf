terraform {
  backend "s3" {
    bucket         = "thej-s3-bucket998877ha"
    dynamodb_table = "state-lock"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    profile = "admin"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "admin"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
}