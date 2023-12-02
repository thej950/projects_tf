terraform {
  required_version = ">=0.12"
}

resource "aws_instance" "ec2_module_1" {

    ami = var.ami_id
    instance_type = var.web_instance_type
    key_name= "aws_key"
    vpc_security_group_ids = [aws_security_group.main.id]

  user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello this is module-1  </h1></body></html>" > /var/www/html/index.html
      EOF
}

resource "aws_security_group" "main" {
    name        = "EC2-webserver-SG-1"
  description = "Webserver for EC2 Instances"

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["136.185.147.218/32"] # here we need to specify our Local machine ip or use 0.0.0.0/0 for everyone to access 
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMTJ4R2gtcHjpmh61cE7omAVGVWQGxQJav7CN3h2kNu+ecCBPHGcR01VYTQVtj35apxa/Ion/9sq8DFIXFWHPQZezzDhAcr5bj52uD0VXIyHXaIqO6Izg/6uN2bTjhbvQpPvLMcZlaLICdxKiXzNXM1B0zd8AHc/NXuwGSVmCyt8sAuYf7wmT7l7tEFKUN/JNhyIDr4UXO3DQHiqYowCsodBxcv1a6sGnwSiSRbq4BgD8u9NqIDfE91h4S9Gz+5AW9ATI9tXmln/A40IKIjyRPCpBZa/IXjgIAXly2kXaZwvB/FtGg6O1AWsg4F4qfJSIBhJx7HemxadigvH3ZnfHkus5rxUSFtzpc2A9mCeFE2OlS7payrwWAB+0k3EfIrsNXhWzeJubDg95vDB2oW8paBejOs/LFGTyuGdb6a0pRgvgO7PCtOZg33tFD1c1xBVSDuv0j0Wn5pOAm78lol1Gnths3fjRcH49JUU0Bath9FuRgwxVAeogrRtS0VxWuAZ8= DELL@Navathej"
}