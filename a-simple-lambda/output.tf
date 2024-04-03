output "lambda_url" {
  value = aws_apigatewayv2_stage.stage.invoke_url
}

output "domain_name_id" {
  description = "The domain name ID."
  value = aws_apigatewayv2_domain_name.hello_world_domain.domain_name
}