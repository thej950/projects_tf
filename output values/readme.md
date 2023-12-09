# Terraform output values
- terraform output values allow to expose the information from our infrastrucher. that might be usefule for external systems or for users of our terraform configurations. 
- Output values can include things like IP address, DNS names, or any other relavent information. 
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

# Below are another some sample syntax for output values 


        resource "aws_instance" "example" {
            ami           = "ami-0c55b159cbfafe1f0"
            instance_type = "t2.micro"

            # other instance configurations...
            }

            output "instance_public_ip" {
            value = aws_instance.example.public_ip
        }

- The aws_instance resource creates an EC2 instance.
- The output block exposes the public IP address of the created instance.

- After applying this configuration, you can use the terraform output command to view the value of the instance_public_ip output.

>> Note: In terraform Data source concepts also same like output values but Both data sources and output values contribute to the flexibility and reusability of Terraform configurations. Data sources enable you to dynamically fetch information during the planning and provisioning phases, while output values allow you to expose relevant information for further consumption or integration with other systems.




