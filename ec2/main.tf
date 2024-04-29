# Generate Key pair to be used in EC2 instances
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

# Create Key Pair in AWS, with the public key generated above
resource "aws_key_pair" "generated_key" {
  key_name   = var.aws_key_name
  public_key = tls_private_key.this.public_key_openssh
  depends_on = [tls_private_key.this]
}

# Create a local file with the private key in PEM format
resource "local_file" "key" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${var.aws_key_name}.pem"
  file_permission = "0400"
  depends_on      = [tls_private_key.this]
}

# Create a VPC with the subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  cidr = var.vpc_cidr

  azs             = var.available_zones
  public_subnets  = var.public_subnets

  map_public_ip_on_launch = true

  create_igw = true

  tags = {
    Name = "vpc-${local.sufix}"
  }
}

# Create a security group that allows inbound traffic and egress traffic
module "security_group" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.0"
  name        = "Public Instance SG"
  description = "Allow SSH inbound traffic and ALL egress traffic"

  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = var.custom_ingress_rules
  egress_with_cidr_blocks  = var.custom_egress_rules

  tags = {
    Name = "sg-${local.sufix}"
  }
}

# Create EC2 instances with the specified parameters
module "ec2_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  for_each = toset(var.instances)

  instance_type               = var.ec2_specs.instance_type
  availability_zone           = element(var.available_zones, 0)
  key_name                    = var.aws_key_name
  ami                         = var.ec2_specs.ami
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
  user_data                   = file("./scripts/userdata.sh")

  root_block_device = [var.ebs_specs]

  tags = {
    Name = "${each.value}"
  }
}

