output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = [for instance in module.ec2_instances : instance.public_ip]
}