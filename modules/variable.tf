variable "web_region" {
  type        = string
  description = "Region of Project"
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "Access key of AWS"
  default     = "AKIARVZBY3GJ4JGV6LX7"
}
variable "secret_key" {
  type        = string
  description = "Secret Access key of AWS"
  default     = "jZ9KS68JITsr9PHSzyzxla/3DyHkQp0dofTqmL5w"
}

/* 

variable "web_instance_type" {
  type        = string
  description = "Instance Type of EC2"
  default     = "t2.micro"
}

variable "ami_id" {
  type        = string
  description = "EC2 Machine AMI id"
  default     = "ami-0767046d1677be5a0"
}

*/