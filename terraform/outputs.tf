output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.devops_server.public_ip
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.devops_server.public_ip}:8080"
}

output "website_url" {
  description = "Website URL"
  value       = "http://${aws_instance.devops_server.public_ip}"
}