provider "aws" {
  region = "us-east-1" # Update with your desired region
}

variable "instance_names" {
  default = ["prod", "qa", "dev"]
}

variable "instance_count" {
  default = 3
}

variable "instance_type" {
  default = "t2.micro"
}
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-keypair" # Update with your desired key pair name
  public_key = file("./aws-keys.pub") # Update with the path to your public key file
}
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  count         = var.instance_count
  ami           = "ami-0c7217cdde317cfec" # Update with your desired AMI ID
  key_name      = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.instance_sg.name]
  instance_type = var.instance_names[count.index] == "prod" ? "t2.large" : var.instance_type
  tags = {
    Name = var.instance_names[count.index]
  }
}
output "instance_details" {
  value = {
    for idx, instance in aws_instance.ec2 : instance.tags.Name => {
      instance_name   = instance.tags.Name
      public_ip       = instance.public_ip
    }
  }
}