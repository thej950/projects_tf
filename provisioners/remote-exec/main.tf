provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
}

resource "aws_instance" "myec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  key_name               = "aws-key2"
  vpc_security_group_ids = [aws_security_group.main-sg2.id]

  provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo 'helloworld from remote provisioner' >> hello.txt",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("C:\\Users\\DELL\\Desktop\\terraorm-work\\provisioners\\remote-exec\\sshkeys\\aws-key2")
    timeout     = "4m"
  }
}

resource "aws_security_group" "main-sg2" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
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

resource "aws_key_pair" "mykey2" {
  key_name   = "aws-key2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHxqL6NRD6yCawzYQFqpVbCekhtV5XC9I2DoaFYURd5Z5Ks523H28TakQoTy4FkDHc/VUeajc3xCfqMUV8wVPJ5AfEfOIsC7LTlOIaL91WeIwHM4gKbXzzTF2CD+OrNWGd/pg1bfTusPe1fehI693OqbrP6t9tBPFbOO4KQjDSWC5AlwL0vm0pbrTib3VlybytzehOXP75CLuqCtrRBeZcmKBD2v9DI03cp6DM7ZDMWX5SEWqYIXv93VV/8ld3qFazXBB0ogFvCZkYf2/NU39hqU10v7a5kU4TGbnjb005wSO4rb6wldGpwXrVQCCuqCE0iTtcUqxyxiGHNeuNqZjURqx18XkiWVeGGK6eoPHWk4QLiRaSUsatc7KfgNVDfiq9VcpKVr4ioq5HHHg1TM7ucPabVHjo97SgPkLcYCFdOD3AeaapBhc+1lrl2icP2pbKpVmRf0GxCmykUpdRuyGgF9SDA823nUAoGx9FQrJX351gcFpdDQgMd+iVUZl3TQc= DELL@Navathej"
}