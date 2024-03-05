variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "allowed_ips" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "username_db" {
  type = string
}

variable "password_db" {
  type = string
}

variable "access_key" {
  type = string
}
variable "secret_key" {
  type = string
}