# GKE Cluster
resource "google_container_cluster" "main" {
  name     = "gke-cluster-${var.environment}"
  location = var.region

  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_name
  subnetwork = var.subnet_name

  deletion_protection = false

  # IP allocation settings
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-range"
    services_secondary_range_name = "gke-services-range"
  }

  # Private Network Configuration
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_cidr
  }

  # Master authorized networks
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0" # For security reasons, restrict to your IP only.
      display_name = "All networks"
    }
  }

  # Addons
  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    network_policy_config {
      disabled = false
    }
  }

  # Network policy
  network_policy {
    enabled = true
  }

  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Configuração de manutenção
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }
}

# Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "node-pool-${var.environment}"
  location   = var.region
  cluster    = google_container_cluster.main.name
  node_count = var.gke_num_nodes

  # Nodes Configuration
  node_config {
    preemptible  = var.preemptible_nodes
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-ssd"

    # Labels and tags
    labels = {
      env = var.environment
    }

    tags = ["gke-node", "gke-${var.environment}"]

    # Workload Identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Security
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  # Auto scaling
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  # Upgrade settings
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }

  # Management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}