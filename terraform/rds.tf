# RDS
resource "aws_db_subnet_group" "subnet" {
  name = "${var.prefix}-db-subnet"

  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]
}

# Parameter group
resource "aws_db_parameter_group" "mysql" {
  name   = "${var.prefix}-parameter-group"
  family = "mysql8.0"
}

# Option group
resource "aws_db_option_group" "mysql" {
  name                 = "${var.prefix}-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# DB Instance
resource "aws_db_instance" "mysql" {
  engine                                = "mysql"
  engine_version                        = "8.0.20"
  license_model                         = "general-public-license"
  identifier                            = "${var.prefix}-db-instance"
  username                              = "root"
  password                              = "password"
  instance_class                        = "db.t3.micro"
  storage_type                          = "gp2"
  allocated_storage                     = 20
  db_subnet_group_name                  = aws_db_subnet_group.subnet.name
  vpc_security_group_ids                = [aws_security_group.rds_sg.id]
  parameter_group_name                  = aws_db_parameter_group.mysql.name
  option_group_name                     = aws_db_option_group.mysql.name
  tags = {
    Name = "${var.prefix}-db-instance"
  }

  lifecycle {
    ignore_changes = [password]
  }
}

output "rds_endpoint" {
  description = "The connection endpoint in address:port format."
  value       = aws_db_instance.mysql.endpoint
}
