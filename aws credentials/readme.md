# Terraform aws credentials

- there are multiple ways to cofigure accesskey and secretkey most popular ways are three ways 
	
	1. Hard coded AWS credentials 
	2. Shared credentials file
	3. Export AWS credentials enviroments variables 


# Hard coded AWS credentials

- This is not recomended in production environment 
- uses of Hard coded aws credentials in main terraform file

		provider "aws" {
			accesskey = "AKIARVZBY3GJSE3OYOOB"
			secretkey = "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"
			region	  = "us-east-1"
		}

# Shared credentials file
- this is a way to store aws credentials in a secret file and pass into main terrafile 
-> way to pass Shared aws credentials inside main terraform file 
	
		provider "aws" {
			region	= "us-east-1"
			shared_credentials_file	= "C:\Users\DELL\.aws\credentials"
        }
		

# Export AWS credentials enviroments variables 

- This is a way to export accesskey and secretkey into variables and pass that variables inside main terraform file 
- To move accesskey and secretkey into system  
	
    	$ export AWS_ACCESS_KEY_ID="AKIARVZBY3GJSE3OYOOB"
	
    	$ export AWS_SECRET_ACCESS_KEY="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"
	
- To usage of those inside main terraform file 
	
		provider "aws" {
			accesskey = "us-east-1"
		}

- after excute terraform init if it is excuting successfully then those access key and secret access key will be exported correctly other wise not 



