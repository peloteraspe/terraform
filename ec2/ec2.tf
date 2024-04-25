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

  network_interface = [
    {
      device_index          = 0
      network_interface_id  = element(module.vpc.public_subnets, 0)
      delete_on_termination = false
    }
  ]

  root_block_device = [var.ebs_specs]

  tags = {
    Name = "${each.value}"
  }
}
