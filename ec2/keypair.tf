resource "tls_private_key" "peloteras" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.aws_key_name
  public_key = tls_private_key.peloteras.public_key_openssh
  depends_on = [tls_private_key.peloteras]
}

resource "local_file" "key" {
  content         = tls_private_key.peloteras.private_key_pem
  filename        = "${var.aws_key_name}.pem"
  file_permission = "0400"
  depends_on      = [tls_private_key.peloteras]
}