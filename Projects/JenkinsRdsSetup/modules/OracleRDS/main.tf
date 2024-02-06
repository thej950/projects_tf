provider "aws" {
  region  = "us-west-1"
  profile = "myaws"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}
# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
  }
}

# Create two subnets in the VPC
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-2"
  }
}

# Create a route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-route-table"
  }
}

# Associate the route table with subnets
resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create a security group for the RDS Oracle instance
resource "aws_security_group" "oracle_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 1521  # Oracle default port
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the RDS Oracle instance in one of the subnets
resource "aws_db_instance" "oracle_instance" {
  identifier             = "oracle-instance"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "oracle-ee"  # Specify Oracle engine type
  engine_version         = "19"        # Specify Oracle version
  instance_class         = "db.t3.large"
  license_model          = "bring-your-own-license"
  username               = "admin1"
  password               = "admin0067Pp"

  publicly_accessible    = true
  multi_az               = false
  backup_retention_period = 7
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.oracle_sg.id]

  db_subnet_group_name = aws_db_subnet_group.oracle_subnet_group.name
  tags = {
    Name = "MyOracleDB"
  }
}

# Create a DB subnet group for Oracle
resource "aws_db_subnet_group" "oracle_subnet_group" {
  name       = "oracle-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "MyOracleDBSubnetGroup"
  }
}

# output.tf

output "oracle_endpoint" {
  value = aws_db_instance.oracle_instance.endpoint
}

output "oracle_username" {
  value = aws_db_instance.oracle_instance.username
}
