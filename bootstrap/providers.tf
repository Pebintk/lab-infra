provider "google" {
  project = var.project_id
  region  = var.region # e.g. us-central1
  zone    = var.zone   # e.g. us-central1-a
}