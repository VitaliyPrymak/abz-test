# Виведення Configuration Endpoint для Redis для підключення
output "redis_configuration_endpoint" {
  value       = aws_elasticache_cluster.redis.configuration_endpoint  # Endpoint для підключення до Redis
  description = "Configuration Endpoint для підключення до Redis"  # Опис
}

# Виведення DNS імені ALB для доступу до нього
output "alb_dns_name" {
  value       = aws_alb.main.dns_name  # DNS ім'я ALB
  description = "DNS ім'я для ALB"  # Опис
}

# Виведення публічної IP-адреси EC2 для доступу до WordPress
output "ec2_public_ip" {
  value       = aws_instance.wordpress.public_ip  # Публічна IP-адреса EC2
  description = "Публічна IP-адреса EC2 для доступу до WordPress"  # Опис
}

output "db_name" {
  value = "wordpress"  # Ім'я бази даних
}

output "db_user" {
  value = var.db_username  # Ім'я користувача бази даних
}

output "db_password" {
  value     = var.db_password  # Пароль до бази даних
  sensitive = true  # Для безпеки, приховуємо пароль
}

output "redis_host" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address  # Хост Redis
}

output "db_host" {
  description = "The endpoint of the RDS database"  # Опис endpoint для RDS
  value       = aws_db_instance.wordpress_db.endpoint  # Endpoint для підключення до RDS
}
