# GKE specific variables
prefix                   = //keep it within 3-5 letters as the code is also generating unique petname along with it.
project_id               = "Your_GCP_Project_Id"
region                   = "australia-southeast1"
network                  = "gce-api-vpc"
gwy_subnet               = "api-gwy-subnet"
machine_type             = "f1-micro"
gwy_subnet_cidr          = "10.10.0.0/24"
zones                    = "australia-southeast1-a"
microservice_subnet      = "microservice-subnet"
microservice_subnet_cidr = "10.20.0.0/24"

create_network          = true
nginx-plus-image-name   = "nginxplus-r22-consul-1-9-0"
nginx-plus-cluster-size = "2"

weather_api_image        = "weather-api-v3"
weather-api-cluster-size = "3"

f1_api_image       = "f1-api-v3"
f1-pi-cluster-size = "3"

hello_nginx_api_image        = "hello-nginxplus-api-v3"
hello-nginx_-pi-cluster-size = "3"
consul_server_cluster_size   = 3
consul_subnet                = "consul-server-subnet"
consul_server_cluster_name   = "consul-server-microservice"
consul_server_source_image   = "consul-server-v1-9-0"
consul_machine_type          = "n2-standard-2"
consul_subnet_cidr           = "10.30.0.0/24"
# Hashicorp Vault
vault-subnet            = "vault-server-subnet"
vault_subnet_cidr       = "10.40.0.0/24"
storage_bucket_location = "asia"

regions = {
  "australia-southeast1" = "10.50.0.0/24"
  "asia-southeast1"      = "10.1.50.0/24"
}

nginx_plus_regions_cidr = {
  "australia-southeast1" = "10.10.0.0/24"
  "asia-southeast1"      = "10.1.10.0/24"
}

consul_regions_cidr = {
  "australia-southeast1" = "10.20.0.0/24"
  "asia-southeast1"      = "10.1.20.0/24"
}

microservice_regions_cidr = {
  "australia-southeast1" = "10.30.0.0/24"
  "asia-southeast1"      = "10.1.30.0/24"
}