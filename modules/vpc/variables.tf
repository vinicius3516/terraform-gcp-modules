# VPC
variable "environment" {
  description = "Environment name"
  type        = string
}

# Subnet
variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
}
variable "region" {
  description = "GCP region"
  type        = string
}
variable "pods_cidr" {
  description = "Pods CIDR"
  type        = string
}
variable "services_cidr" {
  description = "Services CIDR"
  type        = string
}