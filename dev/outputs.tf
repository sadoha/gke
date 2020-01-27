output "cluster_ca_certificate" {
  description = "The CA Certificate of the cluster."
  value     = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}"
  sensitive = false
}
output "cluster_endpoint" {
  description = "The IP address of the cluster master."
  value     = "${google_container_cluster.cluster.endpoint}"
  sensitive = false
}

output "cluster_username" {
  description = "The username to access to the cluster."
  value = google_container_cluster.cluster.master_auth[0].username
  sensitive = false
}

output "cluster_password" {
  description = "The password to access to the cluster "
  value = google_container_cluster.cluster.master_auth[0].password
  sensitive = false
}

output "instance_group_urls" {
  description = "Instance group urls of the cluster"
  value = google_container_cluster.cluster.instance_group_urls
  sensitive = false
}

output "node_config" {
  description = "The node config of the cluster."
  value = google_container_cluster.cluster.node_config
  sensitive = false
}

output "node_pools" {
  description = "The node pool of the cluster."
  value = google_container_cluster.cluster.node_pool
  sensitive = false
}
