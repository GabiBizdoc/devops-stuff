output "lambda_url" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}

output "domain_name_id" {
  description = "The domain name ID."
  value = "https://${var.domain_name}/${var.stage_name}"
}