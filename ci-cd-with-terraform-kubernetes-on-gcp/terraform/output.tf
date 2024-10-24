# cluster name
output "cluster_name" {
    value = google_container_cluster.default.name
  
}

# cluster endpoint
output "cluster_endpoint" {
    value = google_container_cluster.default.endpoint
  
}

# cluster location
output "cluster_location" {
    value = google_container_cluster.default.location
  
}

output "load-balander-ip" {
    value = google_compute_address.default.address
  
}