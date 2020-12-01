resource "google_compute_firewall" "microservice-firewall-rule" {
  depends_on  = [google_compute_network.vpc]
  name        = "${random_pet.pet-prefix.id}-microservice-fw-rule"
  network     = "${random_pet.pet-prefix.id}-${var.network}"
  description = "Allow access to port 3000 to only accessed from nginx plus api gateway."
  allow {
    protocol = "tcp"
    ports = [
      "3000",
    ]
  }
  source_tags = ["${random_pet.pet-prefix.id}-nginx-plus-api-gwy", var.consul_server_cluster_name]

  target_tags = [
    "${random_pet.pet-prefix.id}-microservices", //the firewall rule applies only to instances in the VPC network that have one of these tags, which would be for nginx instances through templates
  ]
}
