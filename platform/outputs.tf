output "eso_service_account_email" {
  description = "Goes on the external-secrets KSA as iam.gke.io/gcp-service-account"
  value       = google_service_account.eso.email
}
