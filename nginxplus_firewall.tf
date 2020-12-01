resource "google_compute_firewall" "nginx-plus-firewall-rule" {
  depends_on  = [google_compute_network.vpc]
  name        = "${random_pet.pet-prefix.id}-nginx-plus-fw-rule"
  network     = "${random_pet.pet-prefix.id}-${var.network}"
  description = "Allow access to ports 22,80,443 and 8080 on all NGINX plus instances."
  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80",
      "443",
      "8080",
    ]
  }
  //source_tags = ["nginx-plus-api-gwy"]

  target_tags = [
    "${random_pet.pet-prefix.id}-nginx-plus-api-gwy", //the firewall rule applies only to instances in the VPC network that have one of these tags, which would be for nginx instances through templates
  ]
}

