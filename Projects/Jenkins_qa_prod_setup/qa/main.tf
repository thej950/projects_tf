variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "sg_for_qa" {}
variable "enable_public_ip_address" {}
variable "user_data_install_qa" {}

output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /Users/rahulwagh/.ssh/aws_ec2_terraform ubuntu@", aws_instance.qa_ec2_instance_ip.public_ip)
}

output "qa_ec2_instance_ip" {
  value = aws_instance.qa_ec2_instance_ip.id
}

output "dev_proj_1_ec2_instance_public_ip" {
  value = aws_instance.qa_ec2_instance_ip.public_ip
}

resource "aws_instance" "qa_ec2_instance_ip" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws-keys"
  vpc_security_group_ids      = var.sg_for_qa
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_qa

}

resource "aws_key_pair" "qa_ec2_instance_public_key" {
  key_name   = "aws-keys"
  public_key = var.public_key
}