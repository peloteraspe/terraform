variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_profile" {
  description = "AWS Profile"
  type        = string
}

variable "aws_key_name" {
  description = "AWS Key Name"
  type        = string
}

variable "tags" {
  description = "Project Tags"
  type        = map(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "available_zones" {
  description = "Available Zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR Public Subnet"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR Private Subnet"
  type        = list(string)
}

variable "custom_ingress_rules" {
  description = "List of ingress rules to be added to security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
    description = string
  }))
}

variable "custom_egress_rules" {
  description = "List of egress rules to be added to security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
    description = string
  }))
}

variable "instances" {
  description = "Instances Name"
  type        = list(string)
}

variable "ec2_specs" {
  description = "Instance Specs"
  type        = map(string)
}

variable "ebs_specs" {
  description = "EBS Specs"
  type = object({
    volume_size = number
    volume_type = string
  })
}