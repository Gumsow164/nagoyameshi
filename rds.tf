#---------------------------------
# RDS Parameter Group
#---------------------------------
resource "aws_db_parameter_group" "mysql" {
  name   = "${var.project}-${var.enviroment}-mysql-parameter-new"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name    = "${var.project}-${var.enviroment}-mysql-parameter-new"
    Project = var.project
    Env     = var.enviroment
  }
}

#---------------------------------
# RDS Option Group
#---------------------------------
resource "aws_db_option_group" "mysql_optiongroup" {
  name                     = "${var.project}-${var.enviroment}-mysql-optiongroup-new"
  engine_name              = "mysql"
  major_engine_version     = "8.0"

  tags = {
    Name    = "${var.project}-${var.enviroment}-mysql-optiongroup-new"
    Project = var.project
    Env     = var.enviroment
  }
}

#---------------------------------
# RDS Subnet Group
#---------------------------------
resource "aws_db_subnet_group" "mysql_subnetgroup" {
  name       = "${var.project}-${var.enviroment}-mysql-subnetgroup-new"
  subnet_ids = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1c.id]

  tags = {
    Name    = "${var.project}-${var.enviroment}-mysql-subnet-group-new"
    Project = var.project
    Env     = var.enviroment
  }
}

#---------------------------------
# RDS Instance
#---------------------------------
resource "aws_db_instance" "mysql" {
  identifier = "${var.project}-${var.enviroment}-mysql-new"

  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted      = false

  db_name  = "nagoyameshi"
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnetgroup.name
  parameter_group_name   = aws_db_parameter_group.mysql.name
  option_group_name      = aws_db_option_group.mysql_optiongroup.name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name    = "${var.project}-${var.enviroment}-mysql-new"
    Project = var.project
    Env     = var.enviroment
  }
}