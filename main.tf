resource "google_compute_instance" "tf_vm" {
  name         = "tf-vm"
  zone         = "us-central1-a"
  machine_type = "n1-standard-2"
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  # Add SSH access to the Compute Engine instance
  metadata = {
    ssh-keys = "${var.gcp-username}:${file("~/.ssh/id_ed25519.pub")}"
  }

  # Add http tag to the instance to identify it in the firewall rule
  tags = ["http"]

  # Startup script
  metadata_startup_script = file("setup-docker.sh")

  network_interface {
    network    = var.gcp-network
    subnetwork = var.gcp-network

    access_config {}
  }
}

resource "google_compute_disk" "tf_disk" {
  name = "tf-disk"
  type = "pd-ssd"
  size = 1
  zone = "us-central1-a"
}

resource "google_compute_attached_disk" "attached_tf_disk" {
  disk     = google_compute_disk.tf_disk.id
  instance = google_compute_instance.tf_vm.id
}

output "tf_vm-internal-ip" {
  value      = google_compute_instance.tf_vm.network_interface[0].network_ip
  depends_on = [google_compute_instance.tf_vm]
}

output "tf_vm-ephemeral-ip" {
  value      = google_compute_instance.tf_vm.network_interface[0].access_config.0.nat_ip
  depends_on = [google_compute_instance.tf_vm]
}
