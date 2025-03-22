# Створення Virtual Private Cloud (VPC) з CIDR блоком 10.0.0.0/16
# VPC є основною мережею, в якій будуть розгорнуті інші ресурси
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # CIDR блок для VPC (можна вказати більше або менше залежно від потреб)
  
  tags = {
    Name = "wordpress-vpc"  # Тег для VPC, щоб позначити її як інфраструктуру для WordPress
  }
}

# Створення Internet Gateway (IGW) для забезпечення доступу до Інтернету для ресурсів у VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id  # Прив'язуємо IGW до основного VPC
}

# Створення публічної підмережі (Public Subnet) для ресурсу в Availability Zone "eu-west-1b"
# Ця підмережа дозволяє ресурсам мати публічні IP-адреси та доступ до Інтернету через IGW
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id  # Підмережа в основному VPC
  cidr_block        = "10.0.1.0/24"    # CIDR блок для публічної підмережі
  availability_zone = "eu-west-1b"     # Розміщуємо підмережу в зоні доступності "eu-west-1b"
}

# Створення публічної підмережі (Public Subnet) в іншій зоні доступності "eu-west-1a"
resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id  # Підмережа в основному VPC
  cidr_block        = "10.0.4.0/24"    # CIDR блок для публічної підмережі
  availability_zone = "eu-west-1a"     # Розміщуємо підмережу в зоні доступності "eu-west-1a"
}

# Створення приватної підмережі для бази даних в зоні доступності "eu-west-1b"
# Приватні підмережі не мають прямого доступу до Інтернету
resource "aws_subnet" "private_db_1" {
  vpc_id            = aws_vpc.main.id  # Підмережа в основному VPC
  cidr_block        = "10.0.2.0/24"    # CIDR блок для приватної підмережі бази даних
  availability_zone = "eu-west-1b"     # Розміщуємо підмережу в зоні доступності "eu-west-1b"
}

# Створення приватної підмережі для бази даних в іншій зоні доступності "eu-west-1a"
resource "aws_subnet" "private_db_2" {
  vpc_id            = aws_vpc.main.id  # Підмережа в основному VPC
  cidr_block        = "10.0.3.0/24"    # CIDR блок для приватної підмережі бази даних
  availability_zone = "eu-west-1a"     # Розміщуємо підмережу в зоні доступності "eu-west-1a"
}
