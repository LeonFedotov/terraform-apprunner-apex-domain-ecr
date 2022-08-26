resource "aws_ecr_repository" "repo" {
  name                 = "${var.service_name}-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
  #pulling dummy image for app runner to start
  provisioner "local-exec" {
    command = <<-EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.repo.repository_url}
      docker pull --platform=linux/amd64 nginx
      docker tag nginx ${aws_ecr_repository.repo.repository_url}
      docker push ${aws_ecr_repository.repo.repository_url}:latest
    EOT
  }
}
