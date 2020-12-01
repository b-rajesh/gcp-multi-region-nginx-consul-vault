resource "google_compute_instance_template" "nginx_plus_gwy_template" {
  name       = "${var.random_id}-${var.region_name}-nginx-plus-gwy-template"
  tags       = ["${var.random_id}-nginx-plus-api-gwy"]
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

  // Create a new boot disk from an image
  disk {
    source_image = var.nginx-plus-image-name
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
  metadata_startup_script = data.template_file.startup_consul_client.rendered //metadata_startup_script = file("${path.module}/add-upstream-nginx.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "nginx_plus_gwy_group_manager" {
  name               = "${var.random_id}-regional-nginx-plus-group-manager"
  base_instance_name = "nginx-plus-api-gwy"
  region             = var.region_name
  //zone               = var.zones
  target_size        = var.nginx-plus-cluster-size
  target_pools       = [google_compute_target_pool.default.id]
  version {
    instance_template = google_compute_instance_template.nginx_plus_gwy_template.id
  }
}

