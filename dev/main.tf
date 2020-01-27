# Enable Kubernetes Engine API for the project.
resource "google_project_service" "cluster" {
  project = var.gcp_project_id
  service = "container.googleapis.com"
}

# https://www.terraform.io/docs/providers/google/r/container_cluster.html
resource "google_container_cluster" "cluster" {
  location = var.gcp_location
  name = var.cluster_name

  # Waits for Kubernetes Engine API to be enabled
  depends_on = ["google_project_service.cluster"]

  # The minimum version of the master. GKE will auto-update the master to new
  # versions, so this does not guarantee the current master version--use the
  # read-only master_version field to obtain that. If unset, the cluster's
  # version will be set by GKE to the version of the most recent official release
  # (which is not necessarily the latest version). Most users will find the
  # google_container_engine_versions data source useful - it indicates which
  # versions are available. If you intend to specify versions manually, the
  # docs describe the various acceptable formats for this field.
  min_master_version = "latest"

  cluster_ipv4_cidr         = var.cluster_ipv4_cidr_block

  enable_kubernetes_alpha   = false

  enable_legacy_abac        = true

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_window_start_time
    }
  }

  # A set of options for creating a private cluster.
  private_cluster_config {
    # Whether the master's internal IP address is used as the cluster endpoint.
    enable_private_endpoint = false
  }

  # Configuration options for the NetworkPolicy feature.
  network_policy {
    # Whether network policy is enabled on the cluster. Defaults to false.
    # In GKE this also enables the ip masquerade agent
    # https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent
    enabled = true

    # The selected network policy provider. Defaults to PROVIDER_UNSPECIFIED.
    provider = "CALICO"
  }

  master_auth {
    # Setting an empty username and password explicitly disables basic auth
    username = ""
    password = ""

    # Whether client certificate authorization is enabled for this cluster.
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # The configuration for addons supported by GKE.
  addons_config {
    # The status of the Kubernetes Dashboard add-on, which controls whether
    # the Kubernetes Dashboard is enabled for this cluster. It is enabled by default.
//    kubernetes_dashboard {
//      disabled = true
//    }

    http_load_balancing {
      disabled = var.http_load_balancing_disabled
    }

    # Whether we should enable the network policy addon for the master. This must be
    # enabled in order to enable network policy for the nodes. It can only be disabled
    # if the nodes already do not have network policies enabled. Defaults to disabled;
    # set disabled = false to enable.
    network_policy_config {
      disabled = false
    }
  }

  # It's not possible to create a cluster with no node pool defined, but we
  # want to only use separately managed node pools. So we create the smallest
  # possible default node pool and immediately delete it.
  remove_default_node_pool = true

  # The number of nodes to create in this cluster (not including the Kubernetes master).
  initial_node_count = 1

  # The desired configuration options for master authorized networks. Omit the
  # nested cidr_blocks attribute to disallow external access (except the
  # cluster node IPs, which GKE automatically whitelists).
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_cidr_blocks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  # Change how long update operations on the cluster are allowed to take
  # before being considered to have failed. The default is 10 mins.
  # https://www.terraform.io/docs/configuration/resources.html#operation-timeouts
  timeouts {
    update = "20m"
  }
}

# https://www.terraform.io/docs/providers/google/r/container_node_pool.html
resource "google_container_node_pool" "node_pool" {
  # The location (region or zone) in which the cluster resides
  location = var.gcp_location

  # The name of the node pool. 
  name = var.node_pools_name 

  # The cluster to create the node pool for.
  cluster = google_container_cluster.cluster.name
  
  # The initial node count for the pool. Changing this will
  # force recreation of the resource.
  initial_node_count = var.initial_node_count

  # Configuration required by cluster autoscaler to adjust 
  # the size of the node pool to the current cluster usage.
  autoscaling {
    # Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count.
    min_node_count = var.autoscaling_min_node_count

    # Maximum number of nodes in the NodePool. Must be >= min_node_count.
    max_node_count = var.autoscaling_max_node_count
  }

  # Node management configuration, wherein auto-repair and auto-upgrade is configured.
  management {
    # Whether the nodes will be automatically repaired.
    auto_repair = var.auto_repair

    # Whether the nodes will be automatically upgraded.
    auto_upgrade = var.auto_upgrade
  }

  # Parameters used in creating the cluster's nodes.
  node_config {
    # The name of a Google Compute Engine machine type. Defaults to
    # n1-standard-1.
    machine_type = var.node_config_machine_type

//    service_account = google_service_account.default.email

    # Size of the disk attached to each node, specified in GB. The smallest
    # allowed disk size is 10GB. Defaults to 100GB.
    disk_size_gb = var.node_config_disk_size_gb 

    # Type of the disk attached to each node (e.g. 'pd-standard' or 'pd-ssd').
    # If unspecified, the default disk type is 'pd-standard'
    disk_type = var.node_config_disk_type 

    # A boolean that represents whether or not the underlying node VMs are
    # preemptible. See the official documentation for more information.
    # Defaults to false.
    preemptible = var.node_config_preemptible 

    # The set of Google API scopes to be made available on all of the node VMs
    # under the "default" service account. These can be either FQDNs, or scope
    # aliases. The cloud-platform access scope authorizes access to all Cloud
    # Platform services, and then limit the access by granting IAM roles
    # https://cloud.google.com/compute/docs/access/service-accounts
    #service_account_permissions
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    # The metadata key/value pairs assigned to instances in the cluster.
    metadata = {
      # https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata
      disable-legacy-endpoints = "true"
    }
  }

  # Change how long update operations on the node pool are allowed to take
  # before being considered to have failed. The default is 10 mins.
  # https://www.terraform.io/docs/configuration/resources.html#operation-timeouts
  timeouts {
    update = "20m"
  }
}

# Fetches the project name, and provides the appropriate URLs to use for container registry.
data "google_container_registry_repository" "cluster" {
  # The GCR region to use.
  region = var.gcp_location
}
