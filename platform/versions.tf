terraform {
  required_version = ">= 1.9"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" # ~> 6.0 = any 6.x, never 7.x
    }
  }
}
terraform {
  backend "gcs" {
    bucket = "ops-lab-506804-tf-state" # literal — no interpolation allowed
    prefix = "platform"
  }
}