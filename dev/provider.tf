provider "google" {
  credentials   = "${file("high-triode-240509-35f2a58343ce.json")}"
  project       = "high-triode-240509"
  region        = "us-central1"
}
