output "instance-ip" {
  value = aws_instance.ec2_laravel.public_ip
}
