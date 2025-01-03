# KEY PAIR

resource "aws_key_pair" "webkp" {
  key_name   = "webkp"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "webkp" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "webkp"
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



# INSTANCES

# WEB SERVERS INSTANCES

resource "aws_instance" "web_Server1" {
  ami                         = "ami-0c76bd4bd302b30ec"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pub1.id
  key_name                    = aws_key_pair.webkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data                   = base64encode(file("user_data.tpl")) # Include a user data script if applicable

  tags = {
    Name = "webServer1"
  }

}

resource "aws_instance" "web_Server2" {
  ami                         = "ami-0c76bd4bd302b30ec"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.pub2.id
  key_name                    = aws_key_pair.webkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data                   = base64encode(file("user_data1.tpl")) # Include a user data script if applicable

  tags = {
    Name = "webServer2"
  }

}

# APP SERVERS INSTANCES

resource "aws_instance" "app_Server1" {
  ami                         = "ami-0c76bd4bd302b30ec"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.priv1.id
  key_name                    = aws_key_pair.webkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id, aws_security_group.lb_sg.id, aws_security_group.db_sg.id]
  associate_public_ip_address = false
  #user_data = base64encode(file("user_data.sh"))  # Include a user data script if applicable

  tags = {
    Name = "appServer1"
  }

}

resource "aws_instance" "app_Server2" {
  ami                         = "ami-0c76bd4bd302b30ec"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.priv2.id
  key_name                    = aws_key_pair.webkp.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id, aws_security_group.lb_sg.id, aws_security_group.db_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "appServer2"
  }

}