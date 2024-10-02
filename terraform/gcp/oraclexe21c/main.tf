resource "google_compute_address" "static_ip" {
  name = "cdc-workshop-oraclexe21c-vm-${random_id.id.hex}"
}

resource "google_compute_network" "vpc_network" {
  name                    = "cdc-workshop-vpc-network-${random_id.id.hex}"
  project                 = var.project_id
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "firewall" {
  name    = "cdc-workshop--firewall-${random_id.id.hex}"
  network = google_compute_network.vpc_network.self_link
  target_tags = ["allow-ssh","allow-oracle"]

  allow {
    protocol = "tcp"
    ports    = ["1521"]
  }

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_project_service" "iap-api" {
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}

data "template_file" "default" {
  template = file("./utils/instance.sh")
  vars = {
    compute_user = "${var.vm_user}"
    cdc_url = "${var.confluentcdcsetup}"
  }
}

resource "google_compute_instance" "cdcworkshop_oracle21c" {
  name         = "cdcworkshop-oracle21c-${random_id.id.hex}"
  machine_type = "n1-standard-4"	
  zone         = var.project_zone
    
  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-8"
      size  = "100" 
      labels = {
         managed_by = "${var.owner_email}"
      }
    }
    
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
      // Ephemeral IP
      nat_ip = google_compute_address.static_ip.address
    }
  }

  tags = ["allow-ssh", "allow-oracle"]

  metadata_startup_script = data.template_file.default.rendered

  provisioner "local-exec" {
    command = "bash ./00_create_client.properties.sh ${google_compute_instance.cdcworkshop_oracle21c.network_interface.0.access_config.0.nat_ip}"
    when = create
  }
}

