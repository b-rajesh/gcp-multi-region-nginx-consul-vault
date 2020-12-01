output "test" {
  description = "Consul UI"
  value       = "http://${google_compute_forwarding_rule.consul_ext_lb_80_forwarding_rule.ip_address}:8500/ui"
}