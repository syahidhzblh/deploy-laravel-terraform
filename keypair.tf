# resource "tls_private_key" "ppk" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }


# resource "aws_key_pair" "laravel_keypair" {
#   key_name   = var.keypair
#   public_key = tls_private_key.ppk.public_key_openssh
# }

# resource "local_file" "ssh_key" {
#   filename        = "laravel-keypair.pem"
#   content         = tls_private_key.ppk.private_key_pem
#   file_permission = "0400"
# }
