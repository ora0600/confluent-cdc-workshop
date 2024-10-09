provider "google" {
  credentials = file(var.gcp_credentials)
  project = var.project_id
  region  = var.project_region
}