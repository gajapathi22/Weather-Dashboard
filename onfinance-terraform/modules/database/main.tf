resource "aws_security_group" "database" {
  name        = "${var.environment}-db-sg"
  description = "Security group for database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Restrict to VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-db-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.environment}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  storage_encrypted       = true
  kms_key_id              = var.kms_key_arn
  
  availability_zones      = var.availability_zones
  skip_final_snapshot     = var.skip_final_snapshot
  
  tags = {
    Name = "${var.environment}-aurora-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count                = var.instance_count
  identifier           = "${var.environment}-aurora-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.instance_class
  engine               = "aurora-postgresql"
  engine_version       = var.engine_version
  db_subnet_group_name = aws_db_subnet_group.main.name
  
  tags = {
    Name = "${var.environment}-aurora-instance-${count.index}"
  }
}