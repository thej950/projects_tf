module "security_group" {
  source              = "./security-groups"
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "jenkins" {
  source                    = "./jenkins"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "Jenkins:Ubuntu Linux EC2"
  public_key                = var.public_key
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./shell_scripts/jenkins-installer.sh", {})
}

module "qa" {
  source                   = "./qa"
  ami_id                   = var.ec2_ami_id
  instance_type            = "t2.medium"
  tag_name                 = "qa:Ubuntu Linux EC2"
  public_key               = var.public_key
  sg_for_qa                = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address = true
  user_data_install_qa     = templatefile("./shell_scripts/qa-installer.sh", {})
}



module "prod" {
  source                   = "./prod"
  ami_id                   = var.ec2_ami_id
  instance_type            = "t2.medium"
  tag_name                 = "prod:Ubuntu Linux EC2"
  public_key               = var.public_key
  sg_for_prod              = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address = true
  user_data_install_prod   = templatefile("./shell_scripts/prod-installer.sh", {})
}


