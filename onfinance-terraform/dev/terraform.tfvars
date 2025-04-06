region            = "us-east-1"
environment       = "dev"
vpc_cidr          = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
cluster_name      = "onfinance-dev"

# EKS
kubernetes_version = "1.27"
node_desired_size  = 2
node_max_size      = 4
node_min_size      = 2
instance_types     = ["t3.medium"]
disk_size          = 20
ssh_key_name       = "testing-key" #H key name here if needed

# Database
db_engine_version  = "13.9"
db_instance_class  = "db.t3.medium"
db_name            = "onfinance"
db_username        = "new_admin"
db_password        = "YourStrongPassword123!" # Replace with a secure password
db_instance_count  = 2

# Storage
bucket_prefix      = "onfinance-data"

# Monitoring
alert_email        = "gajapathikikkara@gmail.com" # Replace with your email