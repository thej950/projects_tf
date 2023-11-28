provider "aws" {
  region = ""
  access_key = ""
  secret_key = ""
}

variable "users_names" {
  description = "IAM users"
  type = list(string)
  default = [ "ramu","ramesh" ]
}

output "print_the_names" {
  value = [for name in var.users_names : name]
}

