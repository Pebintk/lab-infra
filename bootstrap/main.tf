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

# The secret container only — deliberately no google_secret_manager_secret_version.
# A version's secret_data is stored in plaintext in the state file, which lives in
# the bucket above; that would move the secret from Git into state rather than out
# of reach. The value is added out of band:
#
#   echo -n "hello from secret manager" | gcloud secrets versions add lab-app-greeting --data-file=-
#
# Lives in bootstrap/ because the value is data typed in once. In platform/ every
# cluster rebuild would destroy it and it would have to be re-entered by hand.
resource "google_secret_manager_secret" "greeting" {
  secret_id = "lab-app-greeting"

  replication {
    auto {}
  }
}

# Reserved here for the same reason: the entire purpose of a static address is
# surviving cluster rebuilds. In platform/ it would be released and reallocated
# on every destroy cycle and the nip.io hostname would change each time, which
# defeats reserving one at all.
resource "google_compute_address" "ingress" {
  name        = "ingress-ip"
  region      = var.region
  description = "Static address for the cluster's single ingress-nginx LoadBalancer"
}
