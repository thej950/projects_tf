variable "ec2_sg_name" {}

output "sg_ec2_sg_allow_all_id" {
  value = aws_security_group.ec2_sg_allow_all.id
}


resource "aws_security_group" "ec2_sg_allow_all" {
  name        = var.ec2_sg_name
  description = "Enable the All Tracffic"

  # Inbound 
  ingress {
    description = "Allow remote ALL Traffic anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  #Outgoing request
  egress {
    description = "Allow outgoing request"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Groups to allow ALL Traffic"
  }
}
