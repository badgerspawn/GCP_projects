# GKE Cluster
resource "google_container_cluster" "primary" {
  name                     = "${local.resource_prefix}-cluster"
  location                 = var.region
  network                  = google_compute_network.vpc.id
  subnetwork               = google_compute_subnetwork.subnet.id
  project                  = google_project.project.project_id
  remove_default_node_pool = true
  initial_node_count       = 1
  release_channel {
    channel = "REGULAR"
  }
  #min_master_version = data.google_container_engine_versions.latest.release_channel_default_version
  ip_allocation_policy {}
}

# Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "default-node-pool"
  cluster    = google_container_cluster.primary.id
  location   = var.region
  node_count = 1

  node_config {
    machine_type = "e2-micro"
    disk_size_gb = 10
    spot         = true
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

