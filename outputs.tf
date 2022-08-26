output "apprunner_service_url" {
  value = "https://${aws_apprunner_service.application.service_url}"
}

output "ecr_repository_url" {
  value = "${aws_ecr_repository.repo.repository_url}"
}
