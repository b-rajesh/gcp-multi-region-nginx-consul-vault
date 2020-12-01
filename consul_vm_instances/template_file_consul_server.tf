data "template_file" "startup_consul_server" {
  template = "${file("${path.module}/consul-server-startup.sh")}"
  vars = {
    cluster_tag_name = var.consul_server_cluster_name
  }
}