variable "laravel_port" {
  type    = list(any)
  default = [80, 8888, 8080, 443, 22, 2222]
}

resource "aws_security_group" "laravel-sg" {
  name   = "laravel-sg"
  vpc_id = var.vpc_prod

  dynamic "ingress" {
    for_each = var.laravel_port
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
