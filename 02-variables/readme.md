# Enabling Public To ec2 machine
* In this folder practicing bool type variable inside main terrafom file 

> usage of bool type variable

    variable "enable_public_ip" {
        description = "Enable public IP address"
        type        = bool
        default     = true
    }

> To pass variable inside resouce section 

    resource "aws_instance" "myec2" {
        ami                         = "ami-0fc5d935ebf8bc3bc"
        instance_type               = var.instance_type
        count                       = 2
        associate_public_ip_address = var.enable_public_ip
        tags = {
            Name = "My-instance-1"
        }
    }
