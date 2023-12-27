provider "aws" {
  region                   = "ap-south-1"
  shared_credentials_files = ["/Users/DELL/.aws/credentials"]
}

resource "aws_security_group" "sg-1" {
  name        = "shaktiman-sg"
  description = "Allow Inbound Traffic"

  ingress {
    description = "SSH"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "shaktiman_web_access"
    from_port   = "9090"
    to_port     = "9090"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Shaktiman_Web_Access"
  }
}

resource "aws_key_pair" "myec2-key" {
  key_name   = "shaktiman-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtdt0mvm7OFpDXzOZntlJJ5pq9KLYJpLt5LbZGCLbpiR5vObv/F5u4V4ogtj3CjP6HpDo/zN7a9mDQVOD4QE7yyk8rVs0x2zcJ4mtvBaStowE20U6CzJ1ba9FSSUblq39kI8vqYLa3GLS44KWbbRm4jDlzNrKStry7YRUvj7v3FjKx5L09zWxus+sYLlO9UAHc004BbR5QeI+Hmi0nQw5rMBNdkdpo1Hu1qvN/tbgrv+tFLHUwYO39Q4I7hUk3iqttwx/waDAKe3tWVZ6ELKgpsef4FAtINBdpnSyhXGH1ZfW53943QH7UHFZjNOudtVmvbWEnl5TE40pgMbuO4EjlEcl/BJO0WWIWF7qBR1IGS6IDnlE7vrdbHvqpHeLU3ANw660Dhi99DvV4SHpKqGLxavXN/iwtLA9fJoaD/sxgGpfBQeKBSD9/O3FqdN4GjimVAwsXY7gpYENr32oNpAIfLxNh1GyOpT+iKfA2S9zgv4p0a+miwN/2yZXPqof9jRk= DELL@Navathej"
}



resource "aws_instance" "myec2" {
  ami                    = "ami-0287a05f0ef0e9d9a"
  instance_type          = "t2.micro"
  key_name               = "shaktiman-key"
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  user_data              = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo curl -fsSL https://get.docker.com -o docker.sh
                sudo sh docker.sh
                sudo docker pull navathej408/shaktiman:latest
                sudo docker run --name shaktiman -d -p 9090:8080 navathej408/shaktiman:latest
              EOF

  tags = {
    Name = "Docker-Machine"
  }
}

