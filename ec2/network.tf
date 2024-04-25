module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  cidr = var.vpc_cidr

  azs                     = var.available_zones
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true

  create_igw = true
  tags = {
    Name = "vpc-${local.sufix}"
  }

}

module "security_group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.0"
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = var.custom_ingress_rules
  egress_with_cidr_blocks  = var.custom_egress_rules

  tags = {
    Name = "sg-${local.sufix}"
  }
}