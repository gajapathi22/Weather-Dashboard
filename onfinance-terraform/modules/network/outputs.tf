output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.main.id
  
}

output "public_subnet_ids" {
    description = "List of public subnet Ids"
    value = aws_subnet.public[*].id
  
}

output "private_subnet_ids"{
    description = "List of private subnet IDs"
    value = aws_subnet.private[*].id
  
}


output "subnet_ids" {
  description = "List of all subnet IDs"
  value       = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
}