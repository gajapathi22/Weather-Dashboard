output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority" {
  description = "The certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "node_group_id" {
  description = "The ID of the EKS node group"
  value       = aws_eks_node_group.main.id
}