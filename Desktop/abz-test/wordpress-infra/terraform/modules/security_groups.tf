resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  # Дозволяємо доступ лише від ALB на порт 80
  ingress {
    from_port          = 80
    to_port            = 80
    protocol           = "tcp"
    security_groups    = [aws_security_group.alb_sg.id]  # Тільки від ALB
    description        = "Allow HTTP access from ALB"
  }

  # Дозволяємо доступ на порт 443 (HTTPS), якщо є така потреба
  ingress {
    from_port          = 443
    to_port            = 443
    protocol           = "tcp"
    cidr_blocks        = ["0.0.0.0/0"]  # Це можна залишити для відкритого доступу через HTTPS
    description        = "Allow HTTPS access"
  }

  # Дозволяємо доступ по SSH для адміністратора тільки з вказаного IP
  ingress {
    from_port          = 22
    to_port            = 22
    protocol           = "tcp"
    cidr_blocks        = ["178.43.44.48/32"]  # Тільки з твого IP
    description        = "Allow SSH from my IP"
  }

  # Дозволяємо вихідний трафік для EC2 на будь-які порти
  egress {
    from_port          = 0
    to_port            = 0
    protocol           = "-1"  # Вихідний трафік на всі порти
    cidr_blocks        = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-security-group"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  # Дозволяємо доступ до MySQL з EC2
  ingress {
    from_port          = 3306
    to_port            = 3306
    protocol           = "tcp"
    security_groups    = [aws_security_group.ec2_sg.id]  # Тільки з EC2 інстансів
    description        = "Allow MySQL access from EC2 instance"
  }

  egress {
    from_port          = 0
    to_port            = 0
    protocol           = "-1"
    cidr_blocks        = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.main.id

  # Дозволяємо доступ до Redis з EC2
  ingress {
    from_port          = 6379
    to_port            = 6379
    protocol           = "tcp"
    security_groups    = [aws_security_group.ec2_sg.id]  # Тільки з EC2 інстансів
    description        = "Allow Redis access from EC2 instance"
  }

  egress {
    from_port          = 0
    to_port            = 0
    protocol           = "-1"
    cidr_blocks        = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-security-group"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for the ALB"
  vpc_id      = aws_vpc.main.id  # Ідентифікатор твого VPC

  # Дозволяємо доступ з будь-якого IP на порт 80 (HTTP)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Публічний доступ через HTTP
  }

  # Вихідний трафік дозволено на всі порти
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}
