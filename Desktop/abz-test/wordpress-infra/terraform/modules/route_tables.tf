# Створення маршруту для публічних сабнетів через Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Асоціація публічних сабнетів з маршрутом
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Створення Elastic IP для NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

# Створення NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id  # Використовуємо публічний сабнет для NAT Gateway

  tags = {
    Name = "NAT Gateway"
  }
}

# Створення маршруту для приватних сабнетів через NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id  # Вказуємо NAT Gateway
  }

  tags = {
    Name = "Private Route Table"
  }
}

# Асоціація приватних сабнетів з маршрутом
resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.private_db_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.private_db_2.id
  route_table_id = aws_route_table.private_rt.id
}
