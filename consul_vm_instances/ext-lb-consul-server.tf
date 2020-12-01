resource "google_compute_address" "consul_lb_staticip_address" {
  name = "${var.random_id}-${var.region_name}-consul-lb-static-ip"
}

resource "google_compute_forwarding_rule" "consul_ext_lb_80_forwarding_rule" {
  //network               = google_compute_network.vpc.name
  //subnetwork            = google_compute_subnetwork.subnet.name
  region                = var.region_name
  name                  = "${var.random_id}-${var.region_name}-consul-ext-lb"
  target                = google_compute_target_pool.consul_server_loadbalancer.self_link
  load_balancing_scheme = "EXTERNAL"
  //network_tier           = "STANDARD"
  //ip_address  = google_compute_address.consul_lb_staticip_address.address
  ip_protocol = var.protocol
  port_range  = 8500

}


resource "google_compute_target_pool" "consul_server_loadbalancer" {
  name = "${var.random_id}-${var.region_name}-consul-server-loadbalancer"
  region = var.region_name
  //instances        = google_compute_instance_group_manager.nginx-plus-gwy-group-manager.self_link
  //session_affinity = var.session_affinity
  health_checks = google_compute_http_health_check.consul_server_health_check.*.name
}

resource "google_compute_http_health_check" "consul_server_health_check" {
  name = "${var.random_id}-${var.region_name}-consul-server-health-check"

  request_path        = "/v1/agent/checks"
  port                = 8500
  check_interval_sec  = var.health_check_interval
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  timeout_sec         = var.health_check_timeout
}
