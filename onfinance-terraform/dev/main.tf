provider "aws" {
  region = var.region
}

# Create a KMS key for encryption
resource "aws_kms_key" "main" {
  description             = "KMS key for EKS and RDS encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  
  tags = {
    Name = "${var.environment}-kms-key"
  }
}

# Network module
module "network" {
  source = "../modules/network"

  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  cluster_name       = var.cluster_name
}

# EKS module
module "eks" {
  source = "../modules/eks"

  cluster_name         = var.cluster_name
  kubernetes_version   = var.kubernetes_version
  subnet_ids           = module.network.subnet_ids
  private_subnet_ids   = module.network.private_subnet_ids
  vpc_id               = module.network.vpc_id
  node_desired_size    = var.node_desired_size
  node_max_size        = var.node_max_size
  node_min_size        = var.node_min_size
  instance_types       = var.instance_types
  disk_size            = var.disk_size
  ssh_key_name         = var.ssh_key_name
  kms_key_arn          = aws_kms_key.main.arn
  endpoint_public_access = true
}

# Database module
module "database" {
  source = "../modules/database"

  environment        = var.environment
  subnet_ids         = module.network.private_subnet_ids
  vpc_id             = module.network.vpc_id
  availability_zones = var.availability_zones
  engine_version     = var.db_engine_version
  instance_class     = var.db_instance_class
  database_name      = var.db_name
  master_username    = var.db_username
  master_password    = var.db_password
  kms_key_arn        = aws_kms_key.main.arn
  instance_count     = var.db_instance_count
}

# Storage module
module "storage" {
  source = "../modules/storage"

  environment    = var.environment
  bucket_name    = "${var.bucket_prefix}-${var.environment}"
  kms_key_arn    = aws_kms_key.main.arn
}

# Monitoring resources
resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-onfinance-alerts"
}

resource "aws_sns_topic_subscription" "alerts_email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-onfinance-dashboard"
  
  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/EKS", "cluster_failed_node_count", "ClusterName", "${var.cluster_name}"],
          [".", "node_cpu_utilization", ".", "."],
          [".", "node_memory_utilization", ".", "."]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.region}",
        "title": "EKS Cluster Health"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/RDS", "CPUUtilization", "DBClusterIdentifier", "${var.environment}-aurora-cluster"],
          [".", "DatabaseConnections", ".", "."],
          [".", "FreeableMemory", ".", "."]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${var.region}",
        "title": "Database Performance"
      }
    }
  ]
}
EOF
}