# terraform-apprunner-apex-ecr
run `terraform init`
and `terraform apply`
then `docker build --platform=linux/amd64 -t example-server:latest .`
and `aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ECR_REPO_FROM_OUTPUTS`
eventually `docker tag example-server:latest ECR_REPO_FROM_OUTPUTS`
finally `docker push ECR_REPO_FROM_OUTPUTS:latest`
