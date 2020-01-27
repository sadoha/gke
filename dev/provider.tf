provider "google" {
  credentials   = "high-triode-240509-35f2a58343ce.json"
  project = var.gcp_project_id 
  region  = var.gcp_location
}
