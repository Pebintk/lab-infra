output "state_bucket" {
  value = google_storage_bucket.tf_state.name
}

output "registry_host" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.images.repository_id}"
}