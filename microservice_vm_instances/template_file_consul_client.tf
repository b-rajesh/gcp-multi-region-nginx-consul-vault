data "template_file" "startup_consul_client_and_apis" {
  template = "${file("${path.module}/startup.sh")}"
  vars = {
    cluster_tag_name = var.consul_server_cluster_name
  }
}
