output "db_endpoint" {
  description = "The endpoint of the database"
  value       = aws_rds_cluster.aurora.endpoint
}

output "db_reader_endpoint" {
  description = "The reader endpoint of the database"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "db_name" {
  description = "The name of the database"
  value       = var.database_name
}