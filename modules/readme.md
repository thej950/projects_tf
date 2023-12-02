# terraform modules
- terraform modules are used to segregate task in a seperate foleders and used them accordingly whenever required with one main terraform file 
- modules it is concept in terraform to organise of terraforms file with multiple cocepts in a single main terraform file 
- Current folder containe main.tf file which is parent main.tf file 
- Each module containe one main.tf file for that related to that perticular folder which is module 
- In this module suppose in module-1 (installing apache webserver-1 with some content )
- In this module-2 (Installing apache webserver-2 with some content )

# Now create parent  terraform file

- this main.tf file containe to call modules 
- it is located on top folder location 

# To call modules 

        module "thej-webserver-1" {
            source = ".//module-1"
        }
