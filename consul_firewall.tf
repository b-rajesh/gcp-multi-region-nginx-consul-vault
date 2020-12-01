# Allow Consul-specific traffic within the cluster
# - This Firewall Rule may be redundant depnding on the settings of your VPC Network, but if your Network is locked down,
#   this Rule will open up the appropriate ports.
resource "google_compute_firewall" "allow_intracluster_consul" {
  depends_on = [google_compute_network.vpc]
  name       = "${random_pet.pet-prefix.id}-rule-cluster"
  network    = "${random_pet.pet-prefix.id}-${var.network}"
  priority   = 1002
  allow {
    protocol = "tcp"

    ports = [
      var.server_rpc_port,
      var.cli_rpc_port,
      var.serf_lan_port,
      var.serf_wan_port,
      var.http_api_port,
      var.dns_port,
    ]
  }

  allow {
    protocol = "udp"

    ports = [
      var.server_rpc_port,
      var.serf_lan_port,
      var.serf_wan_port,
      var.dns_port,
    ]
  }
  source_ranges = ["0.0.0.0/0", "10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24", "10.10.0.0/24", "10.20.0.0/24", "10.30.0.0/24"]
  source_tags   = [var.consul_server_cluster_name, "${random_pet.pet-prefix.id}-microservices", "${random_pet.pet-prefix.id}-nginx-plus-api-gwy"]
  target_tags   = [var.consul_server_cluster_name, "${random_pet.pet-prefix.id}-microservices", "${random_pet.pet-prefix.id}-nginx-plus-api-gwy"]
}

# Specify which traffic is allowed into the Consul Cluster solely for HTTP API requests
# - This Firewall Rule may be redundant depnding on the settings of your VPC Network, but if your Network is locked down,
#   this Rule will open up the appropriate ports.
# - Note that public access to your Consul Cluster will only be permitted if var.assign_public_ip_addresses is true.
# - This Firewall Rule is only created if at least one source tag or source CIDR block is specified.
resource "google_compute_firewall" "allow_inbound_http_api" {
  //count   = length(var.allowed_inbound_cidr_blocks_dns) + length(var.allowed_inbound_tags_dns) > 0 ? 1 : 0
  depends_on = [google_compute_network.vpc]
  name       = "${random_pet.pet-prefix.id}-rule-external-api-access"
  network    = "${random_pet.pet-prefix.id}-${var.network}"
  priority   = 1001
  allow {
    protocol = "tcp"

    ports = [
      var.http_api_port,
    ]
  }

  source_ranges = ["0.0.0.0/0", "10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24", "10.10.0.0/24", "10.20.0.0/24", "10.30.0.0/24"]
  source_tags   = [var.consul_server_cluster_name, "${random_pet.pet-prefix.id}-microservices", "${random_pet.pet-prefix.id}-nginx-plus-api-gwy"]
  target_tags   = [var.consul_server_cluster_name, "${random_pet.pet-prefix.id}-microservices", "${random_pet.pet-prefix.id}-nginx-plus-api-gwy"]
}

# Specify which traffic is allowed into the Consul Cluster solely for DNS requests
# - This Firewall Rule may be redundant depnding on the settings of your VPC Network, but if your Network is locked down,
#   this Rule will open up the appropriate ports.
# - Note that public access to your Consul Cluster will only be permitted if var.assign_public_ip_addresses is true.
# - This Firewall Rule is only created if at least one source tag or source CIDR block is specified.
resource "google_compute_firewall" "allow_inbound_dns" {
  //count = length(var.allowed_inbound_cidr_blocks_dns) + length(var.allowed_inbound_tags_dns) > 0 ? 1 : 0
  depends_on = [google_compute_network.vpc]
  network    = "${random_pet.pet-prefix.id}-${var.network}"
  name       = "${random_pet.pet-prefix.id}-rule-external-dns-access"
  priority   = 1003
  allow {
    protocol = "tcp"

    ports = [
      var.dns_port,
    ]
  }

  allow {
    protocol = "udp"

    ports = [
      var.dns_port,
    ]
  }

  source_ranges = ["0.0.0.0/0", "10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24", "10.10.0.0/24", "10.20.0.0/24", "10.30.0.0/24"]
  source_tags   = [var.consul_server_cluster_name, "${random_pet.pet-prefix.id}-microservices", "${random_pet.pet-prefix.id}-nginx-plus-api-gwy"]
  target_tags   = [var.consul_server_cluster_name, "${random_pet.pet-prefix.id}-microservices", "${random_pet.pet-prefix.id}-nginx-plus-api-gwy"]
}
