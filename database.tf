provider "aws" {
  region = "us-west-1"
}
  resource "aws_default_vpc" "myvpc"  {
     
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_security_group" "my_database_subnet_group" {
  
  name        = "allow_web"
  description = "Allow web traffic"
  vpc_id = aws_default_vpc.myvpc.id


  
  ingress {
    description      = "My db fgroup"
    from_port        = 3306
    to_port          = 3306
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "ecommerce_public"
  }
}
resource "aws_db_instance" "ecommerce2" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.m5.large"
  db_name                 = "ecommerce2"
  username             = "ecommerceapp"
  password             = "ecommerceapp"
  db_subnet_group_name = aws_db_subnet_group.mydbgroup.id
  publicly_accessible = true
  skip_final_snapshot = true
  snapshot_identifier="ecommerce2-snapshot"
  identifier="ecommerce2"

}


data "aws_db_snapshot" "ecommerce2-snapshot" {
  db_instance_identifier = "ecommerce2"
  most_recent            = true
  
}
resource "aws_db_subnet_group" "mydbgroup" {
  name       = "main"

  subnet_ids = [
    aws_subnet.mydbsubnet1.id,
    aws_subnet.mydbsubnet2.id
  
  ]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_subnet" "mydbsubnet1" {
  availability_zone = "us-west-1b"
  vpc_id=aws_default_vpc.myvpc.id
  cidr_block="172.31.128.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name="db_subnet1"
  }
  
}
resource "aws_subnet" "mydbsubnet2" {
  availability_zone = "us-west-1c"
  vpc_id=aws_default_vpc.myvpc.id
  cidr_block="172.31.144.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name="db_subnet2"
  }
  
}

# Use the latest production snapshot to create a dev instance.
