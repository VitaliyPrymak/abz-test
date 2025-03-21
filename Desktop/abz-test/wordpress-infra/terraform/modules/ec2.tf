data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")
  vars = {
    db_host     = aws_db_instance.wordpress_db.endpoint
    db_name     = "wordpress"
    db_user     = var.db_username
    db_password = var.db_password
    redis_host  = aws_elasticache_cluster.redis.cache_nodes[0].address
  }
}

resource "aws_instance" "wordpress" {
  ami             = "ami-04807f3bd9aa6aab7"  
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data       = data.template_file.user_data.rendered
}
