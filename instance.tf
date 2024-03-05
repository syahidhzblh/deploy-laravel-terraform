resource "aws_instance" "ec2_laravel" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.laravel-sg.id]
  key_name               = var.keypair
  subnet_id              = var.subnet_prod

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 8
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update -y && apt upgrade -y
    timedatectl set-timezone Asia/Jakarta
    sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
    apt install -y nginx
    apt install -y git
    apt install -y php-cli php-xml php-curl php-zip php-mbstring php-dom php8.1-mysql php8.1-fpm
    apt install -y mysql-server
    apt install -y ansible python3 python3-pip
    systemctl start nginx
    service php8.1-fpm start
  EOF

  provisioner "remote-exec" {
    connection {
      host        = aws_instance.ec2_laravel.public_ip
      user        = "ubuntu"
      port        = 2222
      private_key = file("ansible/${var.keypair}.pem")
    }
    inline = ["echo 'Connected!'"]
  }

  #For Mac
  provisioner "local-exec" {
    command = <<-EOF
      sed -i '' -e 's/public/${aws_instance.ec2_laravel.public_ip}/g' /Users/user/Desktop/deploy-laravel-terraform/ansible/hosts
      sleep 200 && ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ansible/hosts ansible/main.yml --private-key=ansible/${var.keypair}.pem
    EOF
  }

  #For Linux
  # provisioner "local-exec" {
  #   command = <<-EOF
  #     sed -i 's/public/${aws_instance.ec2_laravel.public_ip}/g' ansible/hosts
  #     ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i ansible/hosts ansible/main.yml --private-key=ansible/${var.keypair}.pem
  #   EOF
  # }

  tags = {
    Name    = "laravel-server-new"
    Env     = "Production"
    Service = "laravel-app-server"
    Owner   = "Devops"
  }

}
