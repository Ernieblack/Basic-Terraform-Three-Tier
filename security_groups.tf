# SECURITY GROUPS

# Web Server Security Group

resource "aws_security_group" "web_sg" {
  vpc_id      = aws_vpc.web-app-vpc.id
  name        = "web_sg"
  description = "Security group for a web server"

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# App Server Security Group

resource "aws_security_group" "app_sg" {
  vpc_id      = aws_vpc.web-app-vpc.id
  name        = "app-sg"
  description = "Security group for app server"
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for RDS database"
  vpc_id      = aws_vpc.web-app-vpc.id
}

resource "aws_security_group_rule" "app_to_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "db_to_app" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.db_sg.id
}



# # App Server Security Group

# resource "aws_security_group" "app_sg" {
#   vpc_id      = aws_vpc.web-app-vpc.id
#   name        = "app-sg"
#   description = "Allow traffic from host server"

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.web_sg.id, aws_security_group.lb_sg.id]
#   }

#    ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#     security_groups = [aws_security_group.web_sg.id, aws_security_group.lb_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# # Outbound rule to allow EC2 instance to connect to the database
#   egress {
#     from_port   = 3306                   # MySQL port
#     to_port     = 3306
#     protocol    = "tcp"
#     security_groups = [aws_security_group.db_sg.id]
#   }
# }




# resource "aws_security_group" "db_sg" {
#   name        = "db_sg"
#   description = "Security group for RDS database"
#   vpc_id      = aws_vpc.web-app-vpc.id


#   ingress {
#     description     = "Allow MySQL access from app servers"
#     from_port       = 3306
#     to_port         = 3306
#     protocol        = "tcp"
#     security_groups = [aws_security_group.app_sg.id]
#   }


#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }



# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for the Load Balancer"
  vpc_id      = aws_vpc.web-app-vpc.id

  # Allow inbound HTTP traffic from anywhere
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  # Allow outbound traffic to any destination
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "lb_sg"
  }
}

resource "aws_security_group_rule" "allow_lb_health_checkA" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}


resource "aws_security_group_rule" "allow_lb_health_checkB" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.lb_sg.id
}
