output "project_id" {
  value = google_project.project.project_id
}

output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "endpoint" {
  value = google_container_cluster.primary.endpoint
}
