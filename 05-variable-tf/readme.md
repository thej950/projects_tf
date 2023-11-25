# variable.tf
* variable.tf containe variables instead of passing variable inside main terraform file using this variable.tf file we pass variable to main terraform file 
* In this file we normally add variable whatever we required to pass to main terraform file  
* file should be variable.tf file only 

> Basic variable.tf file 

* To create a variable file 

    $ vim variable.tf

* below is the actual conten inside variable.tf file 

 		variable "instance_type" {
		   description = "Instance type t2.micro"
		   type        = string
		   default     = "t2.micro"
		}

* create actual main.tf file and pass variable in that 

		provider "aws" {
		   region     = "eu-central-1"
		   access_key = "<INSERT_YOUR_ACCESS_KEY>"
		   secret_key = "<INSERT_YOUR_SECRET_KEY>"
		}

		resource "aws_instance" "ec2_example" {

		   ami           = "ami-0767046d1677be5a0"
		   instance_type =  var.instance_type

		   tags = {
				   Name = "Terraform EC2"
		   }
		}


