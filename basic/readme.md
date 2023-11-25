* In terraform file mainly there are providers and resources 
* providers actually cloud environments 
* resources are Normally components to create like ec2 instances etc...


# To access aws cloud 

        provider "aws" {
        access_key = "AKIARVZBY3GJYYYBTQ74"
        secret_key = "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"
        region     = "us-east-1"
        }

* From above scenario terraform will download aws related plugins on .terraform folder 

# To add ec2 instance inside aws cloud 

        resource "aws_instance" "my-ec2" {
            ami           = "ami-0fc5d935ebf8bc3bc"
            instance_type = "t2.micro"
            tags = {
                Name = "my-instance"
            }
        }

* from above resorce section in there ec2 machine launch 
> BreakDown of resource section 
* resource "aws_instance" my-ec2" -->aws_instance is component name my-ec2 it is nameing convention for aws cloud 
* ami --> it is id of machine in that perticular region ami-id will be changed perticular region to region 
* instance_type -> To launch an instance with type of instance t2.micro comes with 1CPC and 1GB RAM 
* tags are used to assign Name to machine 

