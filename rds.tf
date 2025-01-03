# RDS Instance
resource "aws_db_instance" "user-database" {
  identifier             = "user-database"
  skip_final_snapshot    = true
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.39"
  instance_class         = "db.t4g.micro"
  db_name                = "user_database"
  username               = "admin"
  password               = "ernie1235#"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "user-database"
  }
}


# Subnet Group for RDS
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.priv3.id, aws_subnet.priv4.id]
}