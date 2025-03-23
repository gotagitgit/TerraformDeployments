output "deployment_summary" {
  value = <<EOT
    
    deploy-lambda Summary:
    ---------------------
    S3 Bucket: ${aws_s3_bucket.deployment_bucket.id}
    Lambda Function: ${aws_lambda_function.api_lambda.function_name}
    API Gateway: ${aws_apigatewayv2_api.lambda_api.name}
    Stage: ${aws_apigatewayv2_stage.lambda_stage.name}
    API Endpoint: ${aws_apigatewayv2_api.lambda_api.api_endpoint}
    EOT
}
