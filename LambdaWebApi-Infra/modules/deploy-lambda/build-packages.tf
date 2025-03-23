# Add this at the top level of your Terraform configuration
locals {  
  publish_dir    = "${var.application_dir}\\bin\\Release\\net8.0\\publish"
  package_path   = ".\\.packages\\${var.package_name}"
}

# publish application
resource "null_resource" "build_application" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      # Create .packages folder if not exists
      New-Item -ItemType Directory -Force -Path ".\.packages"
      
      dotnet publish ${var.application_dir} -c Release
      Compress-Archive -Path "${local.publish_dir}\*" -DestinationPath ${local.package_path} -Force

      echo '\n Published LambdaWebApi into ${local.package_path}'
    EOF
    interpreter = ["PowerShell", "-Command"]
  }
}

# Upload the package to S3
resource "aws_s3_object" "package_upload_to_s3" {
  bucket = var.s3_bucket_name
  key    = "deployments/${local.function_name}.zip"  # S3 path where the zip will be stored
  source = local.package_path
  
  depends_on = [null_resource.build_application]
}