output "ec2_public_ip" {
  description = "Ip Publica de la instancia"
  value       = [for instance in module.ec2_instances : instance.public_ip]
}