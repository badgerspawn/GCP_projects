locals {
  project_name          = "${var.backend_project_id}-${var.env}"
  resource_prefix       = lower("${var.env}-${var.region}")
  resource_short_prefix = replace(local.resource_prefix, "/[^a-zA-Z0-9]/", "")
}

# Create a new GCP Project
resource "google_project" "project" {
  name            = local.project_name
  project_id      = local.project_name
  billing_account = var.billing_account
}

# Enable APIs only if they are not already enabled
resource "google_project_service" "enabled_apis" {
  for_each = toset(var.apis)
  project  = google_project.project.project_id
  service  = each.value

  disable_dependent_services = false
}

# Data Resource to get latest Kubernetes version
data "google_container_engine_versions" "latest" {
  location = var.region
}

