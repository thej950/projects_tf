# Setup Ansible cluster 
- create vpc with myvpc 10.0.0.0/16 range 
- create one subnet with public-subnet 10.0.1.0/24
- create a igw under myvpc
- create RT-1 under myvpc
- Edit route to internet gateway igw
- create route association with attched to public-subent (10.0.1.0/24)
- create security group inder myvpc allow ssh 
- create instance name controller 10.0.1.10 with ansible setup 
- create worker-1 (10.0.1.11) and worker-2 (10.0.1.12) 