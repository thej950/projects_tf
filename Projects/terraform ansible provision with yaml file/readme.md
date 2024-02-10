# apache setup using ansible playbook with Terraform 
- This should be implement on linux 
- install ansible
- install terraform 
- install awscli 

1. write main.tf file with local variables 
2. write apache yaml file for installation of apache
3. write ansible.cfg file 
4. generate sshkeys to connect remote machine securly paste public key in locals

        provisioner "local-exec" {
            command = "ansible-playbook -i 'ubuntu@${aws_instance.apache-server.public_ip},' ${local.apache_yaml_file} --private-key ${local.private_key}"
        }

 - above command used to run ansible playbook from local machine to excute on remote machine 

 
