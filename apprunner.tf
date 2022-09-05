resource "time_sleep" "iam_role_delay" {
  depends_on      = [aws_iam_role.role]
  create_duration = "10s"
}

resource "aws_apprunner_service" "application" {
  depends_on   = [time_sleep.iam_role_delay]
  service_name = "${var.service_name}-app"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.role.arn
    }
    auto_deployments_enabled = true
    image_repository {
      image_identifier      = "${aws_ecr_repository.repo.repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port = 80
      }
    }
  }
}
resource "aws_apprunner_custom_domain_association" "apprunner_custom_domain" {
  domain_name          = var.root_domain_name
  service_arn          = aws_apprunner_service.application.arn
  enable_www_subdomain = false
}