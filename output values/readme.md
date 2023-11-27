# Terraform output values

- terraform output values are used to print desired information on terminal 
- terraform output values can help to print the attributes like (arn, instance_state, outpost_arn, public_ip, and public_dns etc ) on our console. 

> Basic Syntax of Output values

    output "random_output" {
        values = "Hello World"
    }

# To see Public IP of an Instance after complete Launch

> Below Code need to be include in main terraform file 

    output "my_console_output" {
        value = "aws_instance.My-ec2.public_ip
    }
