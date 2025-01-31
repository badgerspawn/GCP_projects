variable "billing_account" {
  description = "billing account"
  type        = string
}

variable "env" {
  description = "environment name"
  type        = string
}

variable "apis" {
  type    = list(string)
  default = []
}

variable "backend_project_id" {
  description = "Project Id to target."
  type        = string
  default     = ""
}

variable "backend_region" {
  description = "Region to target"
  type        = string
  default     = "europe-west2"
}

variable "region" {
  description = "Region to target"
  type        = string
  default     = "europe-west2"
}

variable "subnet_cidr" {
  type = string
}

