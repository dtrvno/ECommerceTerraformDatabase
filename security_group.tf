resource "aws_security_group" "security_group_db" {
  name        = "allow_db"
  description = "Allow db traffic"
  vpc_id = aws_default_vpc.myvpc.id

  ingress {
    description      = "TCP"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "db_sequrity_group"
  }
}
