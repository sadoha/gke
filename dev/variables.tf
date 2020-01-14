variable "name" {
  default 	= "high-triode-240509"
  description 	= "The name of project"
}

variable "region" {
  default 	= "us"
  description 	= "The name of region"
}

variable "env" {
  description 	= "Environment name"
  default 	= "dev" 
}

variable "profile" {
  description 	= "The profile you want to use"
  default     	= "default"
}

variable "initial_node_count" {
  description   = "The initial node count"
  default       = "2"
}
