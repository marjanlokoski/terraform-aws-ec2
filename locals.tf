locals {
  required_tags = {
    ManagedBy      = "Terraform"
  }
  iam_instance_profile = var.instance_profile
  instance_type = var.instance_type
  key_name   = var.key_name
  vpc_id     = var.vpc_id
  kms_key_id = var.kms_key_id
}
