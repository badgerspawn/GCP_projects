variable "project_id" {
  description = "Project Id to target."
  type        = string
}

variable "region" {
  description = "Region to target"
  type        = string
  default     = "europe-west2"
}

variable "backend_storage_bucket" {
  description = "bucket for tfstate"
  type        = string
}
