resource "google_storage_bucket" "image_store" {
  count         = "2"
  name     	= "tf-state-${var.name}-${var.env[count.index]}"
  location 	= "US"
  force_destroy	= "true"
  storage_class	= "STANDARD"
}

