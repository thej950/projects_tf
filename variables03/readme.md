# using list type variable 
* creating multiple IAM users in aws cloud 

> To pass list type variable

    variable "user_names" {
        description = "IAM-Users"
        type        = list(string)
        default     = ["ramu", "raki", "raghu", "ramesh"]
    }

> usage of list type variable inside resource section 

    resource "aws_iam_user" "iam-users" {
        count = length(var.user_names)
        name  = var.user_names[count.index]
    }
* from above code 3 IAM users will be created 

