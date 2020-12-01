resource "google_compute_instance_template" "consul-server-template" {
  name       = "${var.random_id}-${var.region_name}-consul-server"
  tags       = [var.consul_server_cluster_name]
  region = var.region_name
  labels = {
    environment = "dev"
  }
  machine_type = var.consul_machine_type

  metadata = merge(
    {
      "${var.metadata_key_name_for_cluster_size}" = var.consul_server_cluster_size
    },
    var.custom_metadata,
  )

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  disk {
    boot         = true
    auto_delete  = true
    source_image = var.consul_server_source_image
    disk_size_gb = "50"
    disk_type    = "pd-ssd"
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    access_config {
      # The presence of this property assigns a public IP address to each Compute Instance. We intentionally leave it
      # blank so that an external IP address is selected automatically.
      nat_ip = ""
    }
  }
  metadata_startup_script = data.template_file.startup_consul_server.rendered
  service_account {
    email = null
    scopes = concat(
      ["userinfo-email", "compute-ro", var.storage_access_scope],
      var.service_account_scopes,
    )
    #scopes = [
    #"https://www.googleapis.com/auth/compute",
    #]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "consul-server-group-manager" {
  name               = "${var.random_id}-regional-consul-server-group-manager"
  base_instance_name = "consul-server"
  region             = var.region_name
  //zone               = var.zones
  target_size        = var.consul_server_cluster_size
  target_pools       = [google_compute_target_pool.consul_server_loadbalancer.id]
  version {
    instance_template = google_compute_instance_template.consul-server-template.id
  }
}

