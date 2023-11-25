# Multiple tfvars file usage 
* terraform tfvars files are used for to setup multiple environments like example using single main.tf file we can setup multiple environments 
* like we can create  multiple tfvars files based on our requirements 
* file name can be anything but extensions should be .tfvars 
* In this tfvars file containe Actual value of variable.tf 

# Creating Multiple tfvars file use in one single Loaction with one main terraform file 
> creating staging.tfvars

    instance_type="t2.micro"									
		
    enviroment_name="staging"

> creating production.tfvars 

  	instance_type="t2.micro"
		
	environment_name="production" 

> creating variable.tf file 

		
	variable "instance_type" {
	}
		
	variable "environment_name" {
	}

# now To pass variable or include into resource section on main terraform file 


    resource "aws_instance" "my-ec2" {
        ami           = "ami-0fc5d935ebf8bc3bc"
        instance_type = var.instance_type
        tags = {
            Name = var.environment_name
        }
    }


# Now supply different tfvars within the same Location with Single main terraform file using below command 

> Below commands for staging environment 

    $ terraform plan -var-file="staging.tfvars"
    $ terraform apply -var-file="staging.tfvars

> Below commands for Production environment 

    $ terraform plan -var-file="production.tfvars
    $ terraform apply -var-file="production.tfvars 

# To pass default values using command line without creating tfvars files 
- To Apply using command Line 
    
    $ terraform apply -var="instance_type=t2.micro" -var="environment=test"

- To destroy using command Line 
   
    $ terraform destroy -var="instance_type=t2.micro" -var="environment=test"