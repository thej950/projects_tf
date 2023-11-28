# loops with count 
- creating 3 users with loops count 


- To pass variable for loop count 

    variable "user_names" {
        description = "IAM users"
        type = list(string)
        default = [ "thej","sai","ramu" ]
    }


- To Use variable inside resource block for to create users 

    resource "aws_iam_user" "myusers" {
        count = length(var.user_names)
        name = var.user_names[count.index]
    }

