# Terraform Introduction

* terraform is IAAS | it will automates infrastrucher
* Define infrastrucher state 
* Ansible, puppet and chef are automates mostly OS related tasks. to Define machines states 
* Terraform Automate infrastrucher itself Like AWS, GCP, Azure, digital ocean etc..
* Terraform works with automation softwares like ansible after infra is setup and ready 
* No pragramming, Its own syntax similar to JSON. 

# Basic Terraform commands

> To validate terraform code is perfect or not if any syntax error
	
    $ terraform validate 

> To Initialise terraform workspace 	
	
    $ terraform init 
	
> To Give plan of excution on cloud side Like How many resoucers are going to create How many resources delete or modify 

	$ terraform plan 

> To Perform Actual work on the cloud provider 
	
    $ terraform apply 
	
> To set terraform code properly in order even if we write code unorder below command will make order this command will make our code readable 
	
    $ terraform fmt 
	
> To destroy entire infrastrucher what we create previously 
	
    $ terraform destroy 
	
    
# terraform.tfstate 

* terraform.tfstate file maintain all the current activity in the main terraform file like creation of ec2 machine information and all resorces information 
* if we destroy in this file information also removed automatically 
* in simple words it will maintaine state of the main terraform file 
* it will maintaine data in JSON format 

# terraform.tfstate.backup 

* terraform.tfstate.backup file containe backup of terraform.tfstate file information   

# terraform.lock.hcl

* terrform.lock.hcl file is containe version of the cloud providers and their dependencies for specific configurations 
* it will help to ensure same version of provider for every time we used consistently across different commands like terraform init and terraform apply 

# .terraform 

* .terraform is folder it containe terraform plugins of our perticular system 
* it will created when we perform terraform init 
* automatically download plugins and dependencies which is related our code and our System Accordingly  


	
	