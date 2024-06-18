data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}

module "ec2_instance" {
  depends_on = [module.security_group]

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.0"

  for_each = var.name

  name               = each.value.name
  ami                = data.aws_ami.windows.id
  ignore_ami_changes = true
  instance_type      = var.instance_type
  //availability_zone = each.value.availability_zone
  key_name                    = local.key_name
  subnet_id                   = each.value.subnet
  vpc_security_group_ids      = [module.security_group.security_group_id]
  create_iam_instance_profile = false
  iam_instance_profile        = local.iam_instance_profile
  disable_api_stop            = false
  disable_api_termination     = true
  hibernation                 = true
  user_data_base64            = base64encode(templatefile("../../../modules/application/init.ps1", local.userdata_vars))
  user_data_replace_on_change = false

  monitoring         = true
  enable_volume_tags = true
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 100
      kms_key_id  = local.kms_key_id
    },
  ]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
    instance_metadata_tags      = "enabled"
  }

  volume_tags = local.required_tags
  tags = merge(
    { patch = "thursday" },
    { AWSBackupPlan = "${var.awsbackupplan}" },
    { MonitoringEnabled = "True" },
    local.required_tags)
}
