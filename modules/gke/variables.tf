# GKE
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "region" {
  description = "GCP region"
  type        = string
}
variable "project_id" {
  description = "GCP project ID"
  type        = string
}
variable "vpc_name" {
  description = "VPC name"
  type        = string
}
variable "subnet_name" {
  description = "Subnet name"
  type        = string
}
variable "master_cidr" {
  description = "Master CIDR"
  type        = string
}

# Node Pool
variable "gke_num_nodes" {
  description = "Number of nodes"
  type        = number
}
variable "preemptible_nodes" {
  description = "Preemptible nodes"
  type        = bool
}
variable "machine_type" {
  description = "Machine type"
  type        = string
}
variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
}
variable "min_node_count" {
  description = "Minimum number of nodes"
  type        = number
}
variable "max_node_count" {
  description = "Maximum number of nodes"
  type        = number
}