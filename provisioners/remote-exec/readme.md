# remote-exec 
- this remote exec provisioner are used to excute on remote machine 

        provisioner "remote-exec" {
            inline = [
            "touch hello.txt",
            "echo 'helloworld from remote provisioner' >> hello.txt",
            ]
        }
> above remote excution proccess need to included in aws_instance resource 