provider "aws" {
  region = "us-west-1"
}
  resource "aws_default_vpc" "myvpc"  {
     
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_db_instance" "ecommerce2" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t2.small"
  db_name                 = "ecommerce2"
  username             = "ecommerceapp"
  password             = "ecommerceapp"
  db_subnet_group_name = aws_db_subnet_group.mydbgroup.id
  publicly_accessible = true
  skip_final_snapshot = true
  snapshot_identifier="ecommerce2-snapshot"
  identifier="ecommerce2"
  vpc_security_group_ids=[aws_security_group.security_group_db.id]

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
  cidr_block="172.31.2.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name="db_subnet1"
  }
  
}
resource "aws_subnet" "mydbsubnet2" {
  availability_zone = "us-west-1c"
  vpc_id=aws_default_vpc.myvpc.id
  cidr_block="172.31.3.0/24"
  map_public_ip_on_launch="true"
  tags = {
    Name="db_subnet2"
  }
  
}

# Use the latest production snapshot to create a dev instance.
