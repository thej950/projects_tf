variable "min_size" {
  description = "The minimum size of the autoscaling group"
}

variable "max_size" {
  description = "The maximum size of the autoscaling group"
}

variable "desired_capacity" {
  description = "The desired capacity of the autoscaling group"
}

variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use for instances in the autoscaling group"
}

variable "instance_type" {
  description = "The type of instance to launch"
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch instances into"
}
