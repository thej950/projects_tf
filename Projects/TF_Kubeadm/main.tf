module "security_group" {
  source      = "./security-groups"
  ec2_sg_name = "SG for EC2 to enable All Traffic"
}


module "kubeadm" {
  source                    = "./kubeadm"
  count                     = 2
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "kubeadm:Redhat Linux EC2"
  public_key                = var.public_key
  sg_for_kubeadm            = [module.security_group.sg_ec2_sg_allow_all_id]
  enable_public_ip_address  = true
  user_data_install_kubeadm = templatefile("./shell_scripts/kubeadm_script.sh", {})
}

