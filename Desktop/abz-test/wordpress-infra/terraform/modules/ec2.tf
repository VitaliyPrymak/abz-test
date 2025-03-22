# Завантажуємо шаблон скрипту для конфігурації EC2 інстансу (наприклад, для налаштування WordPress)
data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")  # Шлях до файлу шаблону
  vars = {
    db_host     = aws_db_instance.wordpress_db.endpoint  # Хост бази даних
    db_name     = "wordpress"  # Ім'я бази даних
    db_user     = var.db_username  # Користувач бази даних
    db_password = var.db_password  # Пароль бази даних
    redis_host  = aws_elasticache_cluster.redis.cache_nodes[0].address  # Хост Redis
  }
}

# Створюємо EC2 інстанс для розгортання WordPress
resource "aws_instance" "wordpress" {
  ami                    = "ami-04807f3bd9aa6aab7"  # Використовуємо конкретну AMI для EC2
  instance_type          = "t3.micro"  # Тип інстансу
  subnet_id              = aws_subnet.public_1.id  # Прив'язуємо до публічного субнету
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # Прив'язуємо до секюріті групи EC2
  user_data              = data.template_file.user_data.rendered  # Додаємо шаблон налаштування інстансу

  key_name               = "wordpress-key"  # Ключ для SSH доступу

  associate_public_ip_address = true  # Надаємо публічну IP-адресу для доступу

  tags = {
    Name = "wordpress-instance"
  }
}
