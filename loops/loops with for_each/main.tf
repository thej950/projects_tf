provider "aws" {
  region = ""
  access_key = ""
  secret_key = ""
}

resource "aws_iam_user" "myusers" {
  for_each = toset(var.my_list)
  name = each.value
}

variable "my_list" {
  type = list(string)
  default = [ "ravi","raju","raki" ]
}

