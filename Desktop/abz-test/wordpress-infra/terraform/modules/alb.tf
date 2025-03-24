# Створюємо ресурс для Application Load Balancer (ALB) для розподілу HTTP трафіку
resource "aws_alb" "main" {
  name               = "main-alb"  # Ім'я ALB
  internal           = false  # ALB буде публічним (не внутрішнім)
  load_balancer_type = "application"  # Тип ALB - Application Load Balancer
  security_groups    = [aws_security_group.alb_sg.id]  # Прив'язуємо ALB до секюріті групи
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]  # Публічні сабнети для ALB

  # Теги для ALB
  tags = {
    Name = "main-alb"
  }
}

# Створюємо HTTP слухач для ALB, який буде обробляти запити на порт 80
resource "aws_alb_listener" "http_wordpress" {
  load_balancer_arn = aws_alb.main.arn  # Прив'язуємо слухач до основного ALB
  port              = 80  # Порт для HTTP трафіку
  protocol          = "HTTP"  # Протокол, який використовує слухач

  # Дія за замовчуванням для запитів: пересилання запитів до цільової групи
  default_action {
    type             = "forward"  # Тип дії - пересилати трафік
    target_group_arn = aws_lb_target_group.wordpress_tg.arn  # Цільова група для перенаправлення запитів
  }
}

# Створюємо цільову групу для ALB, до якої буде направлятися трафік
resource "aws_lb_target_group" "wordpress_tg" {
  name        = "wordpress-target-group"  # Ім'я цільової групи
  port        = 80  # Порт, на якому працюватиме EC2 для WordPress
  protocol    = "HTTP"  # Протокол для групи
  vpc_id      = aws_vpc.main.id  # VPC, до якого належить цільова група
  target_type = "instance"  # Тип цілі - EC2 інстанс

  # Налаштування для перевірки здоров'я інстансів у групі
  health_check {
    path     = "/"  # Шлях для перевірки здоров'я
    interval = 30  # Інтервал між перевірками
    timeout  = 5  # Час очікування відповіді
    healthy_threshold = 3  # Кількість успішних перевірок для здорової цілі
    unhealthy_threshold = 3  # Кількість неуспішних перевірок для непрацюючої цілі
    matcher  = "200-299"  # Статус код, що означає успішну перевірку
  }

  tags = {
    Name = "wordpress-target-group"
  }
}

# Прив'язуємо EC2 інстанс до цільової групи, щоб ALB міг спрямовувати трафік до нього
resource "aws_lb_target_group_attachment" "wordpress_attachment" {
  target_group_arn = aws_lb_target_group.wordpress_tg.arn  # ARD цільової групи
  target_id        = aws_instance.wordpress.id  # ID EC2 інстансу
  port             = 80  # Порт, через який EC2 буде обробляти трафік
}
