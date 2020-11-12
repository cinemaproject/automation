resource "google_compute_address" "static_ip_cinema" {
  name = "terraform-static-ip-cinema"
  region       = "europe-west3"
  address_type = "EXTERNAL"
}

resource "google_compute_instance" "cinema" {
  name = "cinema"
  machine_type = "e2-standard-2"
  allow_stopping_for_update = "true"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"
    access_config {
        nat_ip = "${google_compute_address.static_ip_cinema.address}"
    }
  }

  metadata_startup_script="sudo -i; echo 'gce-user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; apt-get update; apt install -y nginx python3-pip libgl1-mesa-glx libpq-dev; chmod -R 0777 /var/www/html; git clone https://github.com/cinemaproject/backend.git; cd backend/; pip3 install psycopg2-binary"

 provisioner "local-exec" {
    command = "scp -r static/** ${var.gce_ssh_user}@${google_compute_instance.cinema.network_interface.0.access_config.0.nat_ip}:/var/www/html/"
  }

  provisioner "file" {
    source      = "static/**"
    destination = "/var/www/html/"
  }
  
  tags = ["cinema"]
}

resource "google_compute_firewall" "cinema" {
    name = "default-allow-http-terraform"
    network = "default"

    allow {
        protocol = "tcp"
        ports = ["80", "443", "5000"]
    }

    source_ranges = ["0.0.0.0/0"]
    target_tags = ["cinema"]
}

output "ip" {
  value = "${google_compute_instance.cinema.network_interface.0.access_config.0.nat_ip}"
}
