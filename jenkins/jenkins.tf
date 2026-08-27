resource "google_service_account" "jenkins" {
  account_id   = "jenkins-vm"
  display_name = "Jenkins controller VM"
}

resource "google_project_iam_member" "jenkins_ar" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "e2-medium"          # JVM wants 2GB+; e2-small will OOM
  zone         = var.zone
  labels = {
    role = "jenkins"
  }

  scheduling {
    provisioning_model = "SPOT"
    preemptible        = true
    automatic_restart  = false
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}                  # ephemeral public IP for SSH
  }

  service_account {
    email  = google_service_account.jenkins.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    ssh-keys = "bintang:${file("~/.ssh/id_ed25519.pub")}"
  }
}

output "jenkins_ip" {
  value = google_compute_instance.jenkins.network_interface[0].access_config[0].nat_ip
}
