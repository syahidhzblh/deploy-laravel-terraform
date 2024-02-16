output "instance-ip" {
  value = aws_instance.ec2_laravel.public_ip
}

output "instance_name" {
  value = aws_instance.ec2_laravel.public_dns
}
