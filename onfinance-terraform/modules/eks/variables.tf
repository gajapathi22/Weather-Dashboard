variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the worker nodes"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_types" {
  description = "List of instance types for the worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "disk_size" {
  description = "Disk size for worker nodes in GB"
  type        = number
  default     = 20
}

variable "ssh_key_name" {
  description = "SSH key name for worker nodes"
  type        = string
  default     = ""
}

variable "endpoint_public_access" {
  description = "Whether to enable public access to the EKS API server endpoint"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for secrets encryption"
  type        = string
}