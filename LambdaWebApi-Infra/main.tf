module "lamda-web-api" {
  source = "./modules/deploy-lambda"
  
  application = var.application
  s3_bucket_name = "${var.s3_bucket_name}-${terraform.workspace}"
  s3_key = var.s3_key
  tag = var.tag
  destroy_bucket_on_teardown = terraform.workspace != "prod" # safety for prod not to delete files on teardown
  environment = terraform.workspace
  api_name = var.api_name
  stage_name = var.stage_name
}