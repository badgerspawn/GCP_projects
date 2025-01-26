terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.17.0"
    }
  }

  backend "gcs" {
    bucket = var.backend_storage_bucket
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
}
