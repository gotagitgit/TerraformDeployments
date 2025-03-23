module "lamda-web-api" {
  source = "./modules/deploy-lambda"
  
  api_name = var.api_name
  application = var.application
  application_dir = var.application_dir
  destroy_bucket_on_teardown = terraform.workspace != "prod" # safety for prod not to delete files on teardown
  environment = terraform.workspace
  package_name = var.package_name
  s3_bucket_name = "${var.s3_bucket_name}-${terraform.workspace}"
  s3_key = var.s3_key
  stage_name = var.stage_name
  tag = var.tag
}