# Identity and access for External Secrets Operator.
#
# Layer split: the secret itself is declared in bootstrap/ because it holds data
# that must outlive the cluster. What lives here is *access* to it, which is only
# meaningful while a cluster exists.

# Read rather than declare — bootstrap/ owns this resource. A data source couples
# the two roots by one known string; terraform_remote_state would couple them by
# state file, which is a much larger dependency for no extra information.
data "google_secret_manager_secret" "greeting" {
  secret_id = "lab-app-greeting"
}

resource "google_service_account" "eso" {
  account_id   = "eso-sa"
  display_name = "External Secrets Operator"
}

resource "google_secret_manager_secret_iam_member" "eso_access" {
  secret_id = data.google_secret_manager_secret.greeting.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.eso.email}"
}

# One half of Workload Identity: it lets the Kubernetes SA
# external-secrets/external-secrets impersonate this Google SA. The other half is
# the iam.gke.io/gcp-service-account annotation on that KSA, set in lab-git-ops.
# Neither half does anything on its own, and the failure mode when one is missing
# is a 403 from Secret Manager rather than an error at apply time.
resource "google_service_account_iam_member" "eso_wi" {
  service_account_id = google_service_account.eso.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[external-secrets/external-secrets]"
}
