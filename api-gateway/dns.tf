# Define an AWS API Gateway v2 domain name for the application
resource "aws_apigatewayv2_domain_name" "hello_world_domain" {
  domain_name = var.app_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.hello_world_lambda_certificate.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
  depends_on = [aws_acm_certificate_validation.api]
}

# Define an ACM certificate
resource "aws_acm_certificate" "hello_world_lambda_certificate" {
  domain_name               = var.app_domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["www.${var.app_domain_name}"]

  lifecycle {
    create_before_destroy = true
  }
}

# Define Route53 record for validation
resource "aws_route53_record" "dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.hello_world_lambda_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.app_domain_name_ttl
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# Define Route53 record for API alias
resource "aws_route53_record" "api" {
  name    = aws_apigatewayv2_domain_name.hello_world_domain.domain_name
  type    = "A"
  zone_id = var.route53_zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.hello_world_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.hello_world_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

# Define ACM certificate validation
resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.hello_world_lambda_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_validation : record.fqdn]
}

# Assign the newly created domain to the API
resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.api.id
  domain_name = aws_apigatewayv2_domain_name.hello_world_domain.id
  stage       = aws_apigatewayv2_stage.stage.id
}
