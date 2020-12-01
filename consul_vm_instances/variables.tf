  variable "consul_server_cluster_name" {}
  variable "consul_machine_type"  {}
  variable "consul_server_cluster_size"     {}
  variable "consul_server_source_image"   {}
  variable "vpc_name"  {}
  variable "subnet_name"    {}
  variable "region_name" {}
  variable "storage_access_scope" {}
  variable "random_id" {}
  variable "service_account_scopes" {}
  variable "custom_metadata" {}
  variable "metadata_key_name_for_cluster_size" {}
  variable "protocol" {}
  variable "network" {}

  # Firewall Ports

  variable "server_rpc_port" {
    description = "The port used by servers to handle incoming requests from other agents."
    type        = number
    default     = 8300
  }

  variable "cli_rpc_port" {
    description = "The port used by all agents to handle RPC from the CLI."
    type        = number
    default     = 8400
  }

  variable "serf_lan_port" {
    description = "The port used to handle gossip in the LAN. Required by all agents."
    type        = number
    default     = 8301
  }

  variable "serf_wan_port" {
    description = "The port used by servers to gossip over the WAN to other servers."
    type        = number
    default     = 8302
  }

  variable "http_api_port" {
    description = "The port used by clients to talk to the HTTP API"
    type        = number
    default     = 8500
  }

  variable "dns_port" {
    description = "The port used to resolve DNS queries."
    type        = number
    default     = 8600
  }

  variable "health_check_port" {
    description = "The TCP port number for the HTTP health check request."
    type        = number
    default     = 8080
  }

  variable "health_check_healthy_threshold" {
    description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
    type        = number
    default     = 2
  }

  variable "health_check_unhealthy_threshold" {
    description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 2."
    type        = number
    default     = 2
  }

  variable "health_check_interval" {
    description = "How often (in seconds) to send a health check. Default is 5."
    type        = number
    default     = 5
  }

  variable "health_check_timeout" {
    description = "How long (in seconds) to wait before claiming failure. The default value is 5 seconds. It is invalid for 'health_check_timeout' to have greater value than 'health_check_interval'"
    type        = number
    default     = 5
  }

  variable "health_check_path" {
    description = "The request path of the HTTP health check request. The default value is '/api'."
    type        = string
    default     = "/api"
  }


  variable "allowed_inbound_cidr_blocks_http_api" {
    description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow API connections to Consul."
    type        = list(string)
    default     = ["0.0.0.0/0"]
  }

  variable "allowed_inbound_tags_http_api" {
    description = "A list of tags from which the Compute Instances will allow API connections to Consul."
    type        = list(string)
    default     = []
  }

  variable "allowed_inbound_cidr_blocks_dns" {
    description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow TCP DNS and UDP DNS connections to Consul."
    type        = list(string)
    default     = ["0.0.0.0/0"]
  }

  variable "allowed_inbound_tags_dns" {
    description = "A list of tags from which the Compute Instances will allow TCP DNS and UDP DNS connections to Consul."
    type        = list(string)
    default     = []
  }

  variable "consul_server_allowed_inbound_cidr_blocks_http_api" {
    description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow API connections to Consul."
    type        = list(string)
    default     = ["0.0.0.0/0"]
  }

  variable "consul_server_allowed_inbound_cidr_blocks_dns" {
    description = "A list of CIDR-formatted IP address ranges from which the Compute Instances will allow TCP DNS and UDP DNS connections to Consul."
    type        = list(string)
    default     = ["0.0.0.0/0"]
  }

