# terraform-apprunner-apex-domain-ecr

Terraform module for docker images hosting in apprunner with an apex domain.
Note: this pushes an empty nginx image to ecr upon creation so that apprunner is able to start and release terraform, when a new image is pushed to ecr app runner will deploy new image automatically
Any suggestions or help are more than welcome.

### TODO

- [ ] add logging and status endpoint for tracking deploynments
- [ ] better documentation
- [ ] app runner - Auto scaling config
- [ ] app runner - Health check config
- [ ] simpler initial image in ecr

### Use
Make sure you have a root zone configured for your domain in **route53**.
```tf
  # main.tf
  module "my-example-api-server" {
    source = "github.com/LeonFedotov/terraform-apprunner-apex-ecr"
    service_name = "example-api-server"
    root_domain_name = "example.com"
  }
```
```bash 
$ terraform init
$ terraform apply
```
Then 
```bash 
$ docker build --platform=linux/amd64 -t example-server:latest .
```
And 
```
$ aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ECR_REPO_FROM_OUTPUTS
```
Eventually 
```
$ docker tag example-server:latest ECR_REPO_FROM_OUTPUTS
```
Finally 
```
$ docker push ECR_REPO_FROM_OUTPUTS:latest
```
