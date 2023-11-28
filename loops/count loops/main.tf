provider "aws" {
  region = ""
  access_key = ""
  secret_key = ""
}

resource "aws_iam_user" "myusers" {
count = length(var.user_names)
name = var.user_names[count.index]
}

variable "user_names" {
  description = "IAM users"
  type = list(string)
  default = [ "thej","sai","ramu" ]
}