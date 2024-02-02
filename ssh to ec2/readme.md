Access machine using direct paste public key 
--------------------------------------------------
 ### ssh To ec2 machine  
 - Generate sshkeys on local machine then paste our public key into terraform file it will able to conect remote machine with our local private key 

            ssh-keygen

 > above command will generate one public key and one private key

 - create a resource which is aws_instance with key_name 

    resource "aws_instance" "myec2" {
        ami                    = "ami-0fc5d935ebf8bc3bc"
        instance_type          = "t2.micro"
        key_name               = "aws-key"
        vpc_security_group_ids = [aws_security_group.main-sg.id]
        tags = {
            Name = "My-instance"
        }
    }


 - create a resource aws_security_group  with port open 22

    resource "aws_security_group" "main-sg" {
        egress = [
            {
            cidr_blocks      = ["0.0.0.0/0"]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
            }
        ]
        ingress = [
            {
            cidr_blocks      = ["0.0.0.0/0"]
            description      = ""
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
            }
        ]
    }

 > from above code egress for outbount rules and ingress for inbound rules 

 - Now create resource aws_key_pair 

    resource "aws_key_pair" "myec2key" {
        key_name   = "aws-key"
        public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUUsOUa315grnZ0cHqct8qGIA0nDcn0NTl4h39Miwm9wfot4YnGVAFChnpBvPHA/iftkyq9QKDb1YoNNL0Xxcs6bplQTloXj4MvvJB+x7pe1dLhFzlIzdBUvJZZNxkh3NujUZZ1PAy6yjDK2SAMXtm4R1FGK5zGW4rFcoPwUwYd3uHLiTb40mcY8oA1qpIDn8D/tERVUpS86DCCEN4X6Xzagst8VutfH4g3Sr8aU4W7hpdaO/dwxiSaS0gik7YdSbxiVY9qjHQucTD521sHUJelf6olw6WEpP1yLHjOgcDgpjlbY8ICmonV7Jjj4Az4IKgmk0+fWNDjzAQMmqF6H/h7n6l3pwJnKjPxs1Odt2uPuCr7EZ82higSD+uBQtAVfvt7Xs9jJuc/l0u+g8DB2wmLmgtvD7oRe5tLXxJICkDyEs3obyfWj1b/sTU1NfE582U5yH6lr9PHkemdimE6tZdehhJzvvjJUkFTeqDzYk2ip0VDPiOIYkS2h5wEMEV+6U= DELL@Navathej"
    }  

 - Now connect to remote machine with public ip using private key 

    $ chmod 400 aws-key
    $ ssh -i aws-key ubuntu@12.2.23.3


Upload Pub file into aws console Manually
------------------------------------------
 1. Log in to the AWS Management Console.
 2. Open the EC2 dashboard.
 3. Click the "Import Key Pair" button.
 4. Enter a name for the key pair (e.g., mykey) and paste the content of the mykey.pub file into the "Public Key Contents" field.
 5. Click "Import Key Pair.

        variable "ami_key_pair_name" {
        type    = string
        default = "aws-key"  # Use the same name you entered when importing the key pair in AWS
        }

        resource "aws_instance" "example" {
        ami           = var.ami_id
        instance_type = var.instance_type
        key_name      = var.ami_key_pair_name
        # ... other configurations ...
        }

