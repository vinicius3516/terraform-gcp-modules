# VPC Network
resource "google_compute_network" "main" {
  name                    = "vpc-${var.environment}"
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "REGIONAL"
}

# Subnet for the GKE cluster
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-subnet-${var.environment}"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.main.id

  # Secundaty IP ranges for pods and services
  secondary_ip_range {
    range_name    = "gke-pods-range"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = var.services_cidr
  }

  private_ip_google_access = true
}

# Router para NAT Gateway
resource "google_compute_router" "vpc_router" {
  name    = "router-${var.environment}"
  region  = var.region
  network = google_compute_network.main.id
}

# NAT gateway for internet resource access
resource "google_compute_router_nat" "vpc_nat" {
  name                               = "nat-${var.environment}"
  router                             = google_compute_router.vpc_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall rules
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal-${var.environment}"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr, var.pods_cidr, var.services_cidr]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-${var.environment}"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # For security reasons, restrict to your IP only.
  target_tags   = ["ssh-allowed"]
}