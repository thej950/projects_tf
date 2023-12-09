# In this terraform file i am launching an instance after lauching that instance public IP should be print on terminal
# using data source block i am hold data of aws_instance on based on filter section instance name should be Terraform EC2 only depends on aws_instance name should be myec2 only 
# then after hold data of instance information To print Public_ip in terminal after launch instance use output block for defining information to print public_ip of that pperticular instance 


/*
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform EC2"
  }
}

data "aws_instance" "myawsinstance" {
  filter {
    name   = "tag:Name"
    values = ["Terraform EC2"]
  }

  depends_on = [
    "aws_instance.myec2"
  ]
}

output "fetched_from_public_ip_from_myawsistance" {
  value = data.aws_instance.myawsinstance.public_ip
}

*/

# below process is to launch an amazon instance which is latest one 
provider "aws" {
  region = "us-east-1"
}


data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"

  # other instance configurations...
}
