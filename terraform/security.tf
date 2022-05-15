data "http" "ipify" {
  url = "http://api.ipify.org"
}

locals {
  myip         = chomp(data.http.ipify.body)
  allowed_cidr = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
}

# EC2 SG
resource "aws_security_group" "web_sg" {
  name   = "${var.prefix}-ec2-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-ec2-sg"
  }
}

resource "aws_security_group_rule" "in_ssh_from_myip" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.allowed_cidr]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "in_http_from_myip" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [local.allowed_cidr]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "out_all_from_ec2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

# RDS SG
resource "aws_security_group" "rds_sg" {
  name   = "${var.prefix}-rds-sg"
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-rds-sg"
  }
}

resource "aws_security_group_rule" "in_mysql_from_ec2" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}
