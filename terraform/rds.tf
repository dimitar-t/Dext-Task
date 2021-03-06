resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.db[*].id

  tags = local.tags
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "db-sg"

  tags = local.tags
}

resource "aws_security_group_rule" "db_ingress_rule" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "db_egress_rule" {
  security_group_id = aws_security_group.db_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
}