output "google_storage_bucket_id" {
  value = "${google_storage_bucket.image_store.*.id}"
}
