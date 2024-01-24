# Terraform aws credentials

- there are multiple ways to cofigure accesskey and secretkey most popular ways are three ways 
	
	1. Hard coded AWS credentials 
	2. Shared credentials file
	3. Export AWS credentials enviroments variables 
	4. use profile 


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

- this is when we excute aws configure automatically inside credentials file will be created in that perticular location (C:\Users\DELL\.aws\credentials)
- other wise create a file with below syntax
	
- $ vim credentials

        [default]
        aws_access_key_id = AKIARVZBY3GJSE3OYOOB
        aws_secret_access_key = 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
	


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


# Profile usage 
- use profile inside .aws/credentials

		[raju]
		aws_access_key_id = AKIARVZBY3GJSE3OYOOB
		aws_secret_access_key = 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
		[thej]
		aws_access_key_id = AKIARVZBY3GJZOQ2RTXH
		aws_secret_access_key = 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

- using above .aws/credentials file implement raju or thej inside providers section

		provider "aws" {
			region                   = "ap-south-1"
			profile				     = "thej"
			}

			resource "aws_instance" "my-ec2" {
			ami           = "ami-0fc5d935ebf8bc3bc"
			instance_type = "t2.micro"
			tags = {
				Name = "my-instance"
			}
		}

- from above terraform file using profile name it will take accesskey and secretkey automatically 
