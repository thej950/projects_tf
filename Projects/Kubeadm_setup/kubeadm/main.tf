variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "sg_for_kubeadm" {}
variable "enable_public_ip_address" {}
variable "user_data_install_kubeadm" {}


output "kubeadm_ec2_instance_ip" {
  value = aws_instance.kubeadm_ec2_instance_ip.id
}

output "dev_proj_1_ec2_instance_public_ip" {
  value = aws_instance.kubeadm_ec2_instance_ip.public_ip
}

resource "aws_instance" "kubeadm_ec2_instance_ip" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "aws-keys"
  vpc_security_group_ids      = var.sg_for_kubeadm
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_kubeadm

}

resource "aws_key_pair" "kubeadm_ec2_instance_public_key" {
  key_name   = "aws-keys"
  public_key = var.public_key
}