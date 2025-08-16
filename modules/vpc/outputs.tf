output "vpc_id" {
  description = "VPC ID"
  value       = google_compute_network.main.id
}
output "vpc_name" {
  description = "VPC name"
  value       = google_compute_network.main.name
}
output "subnet_name" {
  description = "Subnet name"
  value       = google_compute_subnetwork.gke_subnet.name
}