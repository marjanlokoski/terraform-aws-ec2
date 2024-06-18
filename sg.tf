module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = var.security_group_name
  description = "Security group for application servers"
  vpc_id      = local.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Allow HTTP access from alb"
      source_security_group_id = var.lbal_sg_id
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow HTTPS access from alb"
      source_security_group_id = var.lbal_sg_id
    }
  ]


  ingress_with_self = [
    {
      description = "Access From itself"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = true
    }
  ]

  egress_with_cidr_blocks = [
    {
      description      = "Allow all traffic to itself"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    }
  ]
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}
