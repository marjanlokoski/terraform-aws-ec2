variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "keypair name"
}

variable "kms_key_id" {
  type        = string
  description = "KMS key id"
}

variable "instance_profile" {
  type        = string
  description = "The IAM instance profile used for the EC2 instances"
}

variable "volume_type" {
  default     = "gp3"
  description = "The type of the ebs volumes"
}
variable "volume_size" {
  type        = number
  description = "The size of the ebs volumes"
  default     = 50
}


variable "vpc_id" {
  type        = string
  description = "VPC ID for the Instance"

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "The VPC ID must be a valid VPC, starting with \"vpc-\"."
  }
}

variable "lbal_sg_id" {
  type        = string
  description = "The security group of the alb"
}

variable "name" {
  type = map(object({
    name   = string
    subnet = string
  }))

  description = "Name of the APP Server"
}

variable "security_group_name" {
  type        = string
  description = "Security group used in application servers"
}

