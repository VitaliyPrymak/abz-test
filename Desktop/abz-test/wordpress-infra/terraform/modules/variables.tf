# Змінна для імені користувача MySQL бази даних WordPress
variable "db_username" {
  description = "The username for the WordPress MySQL database"  # Опис: Ім'я користувача для бази даних WordPress
  type        = string  # Тип: рядок
}

# Змінна для пароля MySQL бази даних WordPress
variable "db_password" {
  description = "The password for the WordPress MySQL database"  # Опис: Пароль для бази даних WordPress
  type        = string  # Тип: рядок
  sensitive   = true    # Позначення, що це чутлива інформація (пароль)
}

# Змінна для визначення регіону AWS для деплойменту інфраструктури
variable "region" {
  description = "The AWS region to deploy infrastructure"  # Опис: Регіон AWS для розгортання інфраструктури
  type        = string  # Тип: рядок
}

# Змінна для адміністративного користувача WordPress
variable "wp_admin_user" {
  description = "The WordPress admin username"  # Опис: Ім'я адміністративного користувача WordPress
  type        = string  # Тип: рядок
}

# Змінна для адміністративної електронної пошти WordPress
variable "wp_admin_email" {
  description = "The WordPress admin email address"  # Опис: Електронна пошта адміністративного користувача WordPress
  type        = string  # Тип: рядок
}

# Змінна для хоста Redis (за замовчуванням встановлюється до адреси Redis кластера)
variable "redis_host" {
  description = "Redis endpoint"  # Опис: Точка доступу Redis (за замовчуванням вказана адреса Redis кластера)
  default     = "wordpress-redis.zwsr1u.0001.euw1.cache.amazonaws.com"  # За замовчуванням адреса Redis кластера
}

# Змінна для хоста бази даних RDS
variable "db_host" {
  description = "The endpoint of the RDS database"  # Опис: Точка доступу до бази даних RDS
  default     = "terraform-20250320225854928200000001.cnyc26ew6qzz.eu-west-1.rds.amazonaws.com"  # За замовчуванням адреса RDS інстансу
}
