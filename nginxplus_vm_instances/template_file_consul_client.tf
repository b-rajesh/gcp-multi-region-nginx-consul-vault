data "template_file" "startup_consul_client" {
  template = "${file("${path.module}/startup-consul-client.sh")}"
  vars = {
    cluster_tag_name = var.consul_server_cluster_name
  }
}
