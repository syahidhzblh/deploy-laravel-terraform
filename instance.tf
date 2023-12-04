resource "aws_instance" "ec2_laravel" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.laravel-sg.id]
  key_name               = aws_key_pair.laravel_keypair

  user_data = <<-EOF

    #!/bin/bash
    apt update -y && apt upgrade -y
    sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
    /etc/init.d/ssh restart
    apt install -y nginx
    systemctl start nginx
    apt install -y git
    apt install -y php-cli php-xml php-curl php-zip php-mbstring php-dom php8.1-mysql
    apt install -y mariadb-server
    curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
    apt install -y node-js

  EOF


  tags = {
    Name    = "laravel-server-tf"
    Env     = "Production"
    Service = "Web Server"
    Owner   = "Devops"
  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 8
  }
}
