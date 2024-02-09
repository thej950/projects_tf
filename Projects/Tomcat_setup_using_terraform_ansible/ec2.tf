resource "aws_instance" "myec2" {
  ami                    = "ami-0fe630eb857a6ec83"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  key_name               = "ansible1"

  tags = {
    Name = "My-Server"
  }


  provisioner "local-exec" {
    command = <<-EOT
    	echo ${aws_instance.myec2.public_ip} | sudo tee -a /etc/ansible/hosts
  EOT
  }
}

