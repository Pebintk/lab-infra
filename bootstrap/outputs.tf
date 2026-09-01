output "state_bucket" {
  value = google_storage_bucket.tf_state.name
}

output "registry_host" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.images.repository_id}"
}

output "greeting_secret_id" {
  description = "Secret Manager secret the app reads through External Secrets Operator"
  value       = google_secret_manager_secret.greeting.secret_id
}

output "ingress_ip" {
  description = "Set this as controller.service.loadBalancerIP on ingress-nginx"
  value       = google_compute_address.ingress.address
}

# nip.io is wildcard DNS: it resolves an IP embedded in the hostname back to that
# IP, dots or dashes. Computed here so there is one authoritative spelling of the
# hostname rather than a dashed address transcribed by hand.
output "ingress_host" {
  description = "Hostname to curl once ingress-nginx is up"
  value       = "lab.${replace(google_compute_address.ingress.address, ".", "-")}.nip.io"
}
