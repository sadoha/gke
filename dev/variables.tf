variable "gcp_project_id" {
  type = string
  default = "high-triode-240509"

  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "cluster_name" {
  type = string
  default = "dev"

  description = <<EOF
The name of the cluster, unique within the project and zone.
EOF
}

variable "gcp_location" {
  type = string
  default = "us-central1"

  description = <<EOF
The location (region or zone) in which the cluster master will be created,
as well as the default node location. If you specify a zone (such as
us-central1-a), the cluster will be a zonal cluster with a single cluster
master. If you specify a region (such as us-west1), the cluster will be a
regional cluster with multiple masters spread across zones in that region.
Node pools will also be created as regional or zonal, to match the cluster.
If a node pool is zonal it will have the specified number of nodes in that
zone. If a node pool is regional it will have the specified number of nodes
in each zone within that region. For more information see: 
https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters
EOF
}

variable "daily_maintenance_window_start_time" {
  type = string
  default = "00:00"

  description = <<EOF
The start time of the 4 hour window for daily maintenance operations RFC3339
format HH:MM, where HH : [00-23] and MM : [00-59] GMT.
EOF
}

variable "node_pools_name" {
  type = string
  default = "my-node-pool"

  description = <<EOF
name - The name of the node pool, which will be suffixed with '-pool'.
EOF
}

variable "initial_node_count" {
  type = string
  default = "1"

  description = <<EOF
initial_node_count - The initial node count for the pool. Changing this will
force recreation of the resource.
EOF
}

variable "autoscaling_min_node_count" {
  type = string
  default = "1"

  description = <<EOF
autoscaling_min_node_count - Minimum number of nodes in the NodePool. Must be
>=0 and <= max_node_count.
EOF
}

variable "autoscaling_max_node_count" {
  type = string
  default = "3"

  description = <<EOF
autoscaling_max_node_count - Maximum number of nodes in the NodePool. Must be
>= min_node_count.
EOF
}

variable "auto_repair" {
  type = string
  default = "true"

  description = <<EOF
auto_repair - Whether the nodes will be automatically repaired.
EOF
}

variable "auto_upgrade" {
  type = string
  default = "true"

  description = <<EOF
auto_upgrade - Whether the nodes will be automatically upgraded.
EOF
}

variable "node_config_machine_type" {
  type = string
  default = "n1-standard-1"

  description = <<EOF
node_config_machine_type - The name of a Google Compute Engine machine type.
Defaults to n1-standard-1. To create a custom machine type, value should be
set as specified here:
https://cloud.google.com/compute/docs/reference/rest/v1/instances#machineType
EOF
}

variable "node_config_disk_type" {
  type = string
  default = "pd-standard"

  description = <<EOF
node_config_disk_type - Type of the disk attached to each node (e.g.
'pd-standard' or 'pd-ssd'). 
EOF
}

variable "node_config_disk_size_gb" {
  type = string
  default = "30"

  description = <<EOF
node_config_disk_size_gb - Size of the disk attached to each node, specified
in GB. The smallest allowed disk size is 10GB. Defaults to 100GB.
EOF
}

variable "node_config_preemptible" {
  type = string
  default = "false"

  description = <<EOF
node_config_preemptible - Whether or not the underlying node VMs are
preemptible. See the official documentation for more information. Defaults to
false. https://cloud.google.com/kubernetes-engine/docs/how-to/preemptible-vms
EOF
}

variable "cluster_ipv4_cidr_block" {
  type = string
  default = "10.32.0.0/14"

  description = <<EOF
The IP range in CIDR notation to use for the hosted cluster network. This 
range will be used for assigning internal IP addresses to the cluster or set 
of cluster, as well as the ILB VIP. 
EOF
}

variable "http_load_balancing_disabled" {
  type = string
  default = "false"

  description = <<EOF
The status of the HTTP (L7) load balancing controller addon, which makes it 
easy to set up HTTP load balancers for services in a cluster. It is enabled 
by default; set disabled = true to disable.
EOF
}

variable "master_authorized_networks_cidr_blocks" {
  type = list(map(string))

  default = [
    {
      # External network that can access Kubernetes master through HTTPS. Must
      # be specified in CIDR notation. This block should allow access from any
      # address, but is given explicitly to prevernt Google's defaults from
      # fighting with Terraform.
      cidr_block = "0.0.0.0/0"
      # Field for users to identify CIDR blocks.
      display_name = "default"
    },
  ]

  description = <<EOF
Defines up to 20 external networks that can access Kubernetes master
through HTTPS.
EOF
}
