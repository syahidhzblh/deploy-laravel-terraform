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

  provisioner "local-exec" {
    command = "ansible-playbook ansible/main.yml --private-key=${var.keypair}.pem"
  }

  tags = {
    Name    = "laravel-server-tf"
    Env     = "Production"
    Service = "laravel-app-server"
    Owner   = "Devops"
  }

}
