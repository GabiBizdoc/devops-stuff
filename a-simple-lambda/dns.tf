resource "aws_apigatewayv2_domain_name" "hello_world_domain" {
  domain_name = var.domain_name
  #  security_policy          = "TLS_1_2"
  #  regional_certificate_arn = aws_acm_certificate_validation.api.certificate_arn

  domain_name_configuration {
#    certificate_arn = aws_acm_certificate_validation.api.certificate_arn
    certificate_arn = aws_acm_certificate.hello_world_lambda_certificate.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_acm_certificate" "hello_world_lambda_certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["www.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_validation" {
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
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.hello_world_lambda_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.api_validation : record.fqdn]
}

resource "aws_api_gateway_base_path_mapping" "domain_mapping" {
  api_id      = aws_apigatewayv2_api.api.id
  stage_name  = aws_apigatewayv2_stage.stage.name
  domain_name = aws_apigatewayv2_domain_name.hello_world_domain.domain_name
}
