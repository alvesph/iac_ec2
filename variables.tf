variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "allowed_ips" {
  type = list(string)
}