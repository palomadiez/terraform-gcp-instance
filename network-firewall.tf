# create network
resource "google_compute_network" "vpc_network" { 
  name = var.gcp_network 
} 

# allow http traffic
resource "google_compute_firewall" "allow_icmp" {
  name    = "terraform_allow_icmp"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

# allow ssh traffic
resource "google_compute_firewall" "allow_ssh" {
  name    = "terradorm_allow_ssh"
  network = google_compute_network.vpc_network.name 
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "firewall_internal" {
  name    = "terraform_allow_internal" 
  network = google_compute_network.vpc_network.name

allow { 
    protocol = "tcp" 
    ports    = ["0-65535"] 
  } 
 
  allow { 
    protocol = "udp" 
    ports    = ["0-65535"] 
  } 
 
  allow { 
    protocol = "icmp" 
  } 
 
  source_ranges = ["10.128.0.0/20"] 
}