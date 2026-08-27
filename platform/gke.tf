# platform/main.tf
resource "google_container_cluster" "lab" {
  name     = "lab"
  location = var.zone                  # zonal — free-tier cluster fee
  network  = "default"

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  logging_config    { enable_components = ["SYSTEM_COMPONENTS"] }
  monitoring_config { enable_components = ["SYSTEM_COMPONENTS"] }
}

resource "google_container_node_pool" "spot" {
  name    = "spot-pool"
  cluster = google_container_cluster.lab.name
  location = var.zone

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }
  node_config {
    machine_type = "e2-standard-2"
    spot         = true
    disk_size_gb = 30
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}