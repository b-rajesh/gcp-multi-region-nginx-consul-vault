# Provider
provider "google" {
  project = var.project_id
  region  = var.region
  //zone    = var.zones
}

resource "random_pet" "pet-prefix" {
  length = 1
  prefix = var.prefix
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${random_pet.pet-prefix.id}-${var.network}"
  auto_create_subnetworks = "false"
}

# API Gateway Subnet
resource "google_compute_subnetwork" "nginx_gwy_subnet" {
  for_each      = var.nginx_plus_regions_cidr
  name          = "${random_pet.pet-prefix.id}-${each.key}-${var.gwy_subnet}"
  region        = each.key
  network       = google_compute_network.vpc.name
  ip_cidr_range = each.value
}

# Microservice Subnet
resource "google_compute_subnetwork" "microservice_subnet" {
  for_each      = var.microservice_regions_cidr
  name          = "${random_pet.pet-prefix.id}-${each.key}-${var.microservice_subnet}"
  region        = each.key
  network       = google_compute_network.vpc.name
  ip_cidr_range = each.value
}

# Consul Subnet
resource "google_compute_subnetwork" "consul_sever_subnet" {
  for_each      = var.consul_regions_cidr
  name          = "${random_pet.pet-prefix.id}-${each.key}-${var.consul_subnet}"
  region        = each.key
  network       = google_compute_network.vpc.name
  ip_cidr_range = each.value
}

module "consul_instances" {
  depends_on                         = [google_compute_subnetwork.consul_sever_subnet]
  source                             = "./consul_vm_instances"
  for_each                           = var.consul_regions_cidr
  consul_server_cluster_name         = var.consul_server_cluster_name
  consul_machine_type                = var.consul_machine_type
  consul_server_cluster_size         = var.consul_server_cluster_size
  consul_server_source_image         = var.consul_server_source_image
  vpc_name                           = google_compute_network.vpc.name
  subnet_name                        = "${random_pet.pet-prefix.id}-${each.key}-${var.consul_subnet}"
  region_name                        = each.key
  storage_access_scope               = var.storage_access_scope
  random_id                          = "${random_pet.pet-prefix.id}"
  service_account_scopes             = var.service_account_scopes
  custom_metadata                    = var.custom_metadata
  metadata_key_name_for_cluster_size = var.metadata_key_name_for_cluster_size
  protocol                           = var.protocol
  network                            = var.network

}

module "nginx_instacnes" {
  depends_on                         = [google_compute_subnetwork.nginx_gwy_subnet, module.consul_instances]
  source                             = "./nginxplus_vm_instances"
  for_each                           = var.nginx_plus_regions_cidr
  subnet_name                        = "${random_pet.pet-prefix.id}-${each.key}-${var.gwy_subnet}"
  custom_metadata                    = var.custom_metadata
  zones                              = var.zones
  nginx-plus-cluster-size            = var.nginx-plus-cluster-size
  consul_server_cluster_name         = var.consul_server_cluster_name
  machine_type                       = var.machine_type
  network                            = var.network
  nginx-plus-image-name              = var.nginx-plus-image-name
  random_id                          = "${random_pet.pet-prefix.id}"
  vpc_name                           = google_compute_network.vpc.name
  metadata_key_name_for_cluster_size = var.metadata_key_name_for_cluster_size
  consul_client_cluster_size         = var.consul_client_cluster_size
  region_name                        = each.key
  health_check_path                  = var.health_check_path
  health_check_port                  = var.health_check_port
  health_check_interval              = var.health_check_interval
  health_check_healthy_threshold     = var.health_check_healthy_threshold
  health_check_unhealthy_threshold   = var.health_check_unhealthy_threshold
  health_check_timeout               = var.health_check_timeout
  protocol                           = var.protocol

}

module "microservice_instacnes" {
  depends_on                         = [google_compute_subnetwork.microservice_subnet, module.consul_instances, module.nginx_instacnes]
  source                             = "./microservice_vm_instances"
  for_each                           = var.microservice_regions_cidr
  subnet_name                        = "${random_pet.pet-prefix.id}-${each.key}-${var.microservice_subnet}"
  custom_metadata                    = var.custom_metadata
  zones                              = var.zones
  nginx-plus-cluster-size            = var.nginx-plus-cluster-size
  consul_server_cluster_name         = var.consul_server_cluster_name
  machine_type                       = var.machine_type
  network                            = var.network
  random_id                          = "${random_pet.pet-prefix.id}"
  vpc_name                           = google_compute_network.vpc.name
  metadata_key_name_for_cluster_size = var.metadata_key_name_for_cluster_size
  consul_client_cluster_size         = var.consul_client_cluster_size
  region_name                        = each.key
  f1_api_image                       = var.f1_api_image
  f1-pi-cluster-size                 = var.f1-pi-cluster-size
  hello_nginx_api_image              = var.hello_nginx_api_image
  hello-nginx_-pi-cluster-size       = var.hello-nginx_-pi-cluster-size
  weather_api_image                  = var.weather_api_image
  weather-api-cluster-size           = var.weather-api-cluster-size

}
/*
# Vault Subnet
resource "google_compute_subnetwork" "vault-sever-subnet" {
  name          = "${random_pet.pet-prefix.id}-${var.vault-subnet}"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vault_subnet_cidr
}
*/
