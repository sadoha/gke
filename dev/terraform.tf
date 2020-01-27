terraform {
  required_version 	= "~> 0.12"
  backend "gcs" {
    bucket  		= "tf-state-projectname-dev"
    prefix  		= "terraform/state"
    credentials	 	= "high-triode-240509-35f2a58343ce.json"
  }
}
