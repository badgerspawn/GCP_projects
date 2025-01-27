variable "env" {
  description = "environment name"
  type        = string
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

variable "project_name" {
  description = "Project name to target."
  type        = string
}

variable "region" {
  description = "Region to target"
  type        = string
  default     = "europe-west2"
}
