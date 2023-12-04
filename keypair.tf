resource "tls_private_key" "ppk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "laravel_keypair" {
  key_name   = var.keypair
  public_key = tls_private_key.ppk
}
