terraform {
  backend "gcs" {
    bucket  = "tf-state-projectname-dev"
    prefix  = "terraform/state"
    credentials = "high-triode-240509-35f2a58343ce.json"
  }
}
