resource "google_storage_bucket" "tf_state" {
  name                        = "${var.project_id}-tf-state"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_artifact_registry_repository" "images" {
  repository_id = "lab-images"
  location      = var.region
  format        = "DOCKER"
  description   = "Container images for the lab platform"
}