variable region {
 default = "us-east-1"
}

variable "service_name" {
  type = string
  description = "The name that the app runner is given"
  default = "my app runner"
}

variable "root_domain_name" {
  type = string
  description = "server domain name"
  default = "example.com"
}
