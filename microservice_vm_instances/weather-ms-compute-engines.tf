resource "google_compute_instance_template" "weather-microservice-template" {
  name       = "${var.random_id}-${var.region_name}-weather-ms-template"
  tags       = ["${var.random_id}-microservices"]
  region = var.region_name
  labels = {
    environment = "dev"
  }
  machine_type   = var.machine_type
  can_ip_forward = false
  metadata = merge(
    {
      "${var.metadata_key_name_for_cluster_size}" = var.consul_client_cluster_size
    },
    var.custom_metadata,
  )
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  disk {
    source_image = var.weather_api_image
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    access_config {
    }
  }
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
    ]
  }
  /* 
  service_account {
    email = null
    scopes = concat(
      ["userinfo-email", "compute-ro", var.storage_access_scope],
      var.service_account_scopes,
    )
  }
*/
  metadata_startup_script = data.template_file.startup_consul_client_and_apis.rendered //file("${path.module}/weather-startup.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "weather-microservice-group-manager" {
  name               = "${var.random_id}-regional-weather-ms-instance-group-manager"
  base_instance_name = "weather-microservice"
  region             = var.region_name
  //zone             = var.zones
  target_size        = var.weather-api-cluster-size
  version {
    instance_template = google_compute_instance_template.weather-microservice-template.id
  }
}