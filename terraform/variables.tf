# Common
variable "prefix" {
  description = "Project name given as a prefix"
  type        = string
  default     = "techbookhub"
}

# EC2
variable "allowed_cidr" {
  default = null
}
