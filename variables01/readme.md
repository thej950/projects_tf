# string type variable 
* In this main.tf file using variables it is string type varibale 

> Basic usage of string type variable in main terraform file  

    variable "instance_type" {
        description = "instance type t2.micro"
        type        = string
        default     = "t2.micro"
    }

> To pass variables inside main terraform file

    resource "aws_instance" "myec2" {
        ami           = "ami-0fc5d935ebf8bc3bc"
        instance_type = var.instance_type
        tags = {
            Name = "My-instance"
        }
    }
