resource "google_compute_instance" "tf_vm" {
  name         = "tf-vm"
  zone         = "us-central1-c"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # SSH access
  metadata = {
    ssh-keys = "${var.gcp_username}:${file("~/.ssh/id_rsa.pub")}"
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {}
  }
}

output "tf_vm_internal_ip" {
  value = google_compute_instance.tf_vm.network_interface[0].network_ip
}

output "tf_vm_ephemeral_ip" {
  value = google_compute_instance.tf_vm.network_interface[0].access_config[0].nat_ip
}