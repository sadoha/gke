resource "google_storage_bucket" "image_store" {
  name     	= "test-ololo-11"
  location 	= "US"
  force_destroy	= "true"
  storage_class	= "STANDARD"
}

