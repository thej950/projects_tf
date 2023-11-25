# using map type variable

> To Pass map type variable 

    variable "project_environment" {
        description = "project name and environment"
        type        = map(string)
        default = {
            "project"   = "project-alpha"
            environment = "dev"
        }
    }

> To include map type variable inside resource section 

    resource "aws_instance" "myec2" {
        ami           = "ami-0fc5d935ebf8bc3bc"
        instance_type = "t2.micro"
        tags          = var.project_environment
    }




