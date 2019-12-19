variable "name" {
  default 	= "projectname"
  description 	= "The name of project"
}

variable "env" {
  description 	= "Environment name"
  type    	= "list"
  default = [
		"dev",
		"qa",
	    ]
}

variable "profile" {
  description = "The profile you want to use"
  default     = "default"
}

