# local-exec 
- this local-exec provisioner are used to perform on local machine where terrafirm is implementing 

- Adding resource aws_instance with local-exec proviosioner 

        resource "aws_instance" "myec2" {
            ami           = "ami-0fc5d935ebf8bc3bc"
            instance_type = "t2.micro"
            tags = {
                Name = "My-instance"
            }
            provisioner "local-exec" {
                command = "echo 'HelloWorld' > output.txt"
            }
        }

> above local-exec This will create a file named output.txt in the same directory as your Terraform configuration, containing the "HelloWorld" string.
