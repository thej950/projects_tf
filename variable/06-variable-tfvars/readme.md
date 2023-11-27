# file.tfvars
* this file name can be anything but extension should be .tfvars only 
* In this tfvars file containe actual value of variable.tf file 
* here In this folder main.tf file is main terraform file to setup machines and variable.tf file containe variable information and tfvars file containe actual value information for variable ( like default value )

> creating variable.tf file 
   
    variable "instance_type" {

    }

> creating terraform.tfvars file 

    instance_type="t2.micro"

> Now include varibale into  main.tf file 


	resource "aws_instance" "ec2_example" {
		ami           = "ami-0767046d1677be5a0"
		instance_type =  var.instance_type
		tags = {
			   Name = "Terraform EC2"
		}
	}

