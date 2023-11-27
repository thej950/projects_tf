
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
}

# to create multiple users

resource "aws_iam_user" "iam-users" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

variable "user_names" {
  description = "IAM-Users"
  type        = list(string)
  default     = ["ramu", "raki", "raghu", "ramesh"]
}