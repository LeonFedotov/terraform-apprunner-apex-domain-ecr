data "aws_route53_zone" "root_zone" {
  name = var.root_domain_name
}

resource "aws_route53_record" "root_record" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = var.root_domain_name
  type    = "A"
  alias {
    evaluate_target_health = false
    name                   = aws_apprunner_custom_domain_association.apprunner_custom_domain.dns_target
    zone_id                = local.zones[var.region] #lol :'( https://docs.aws.amazon.com/general/latest/gr/apprunner.html
  }
}

resource "aws_route53_record" "apprunner_acm_val_record0" {
  allow_overwrite = true
  name            = tolist(aws_apprunner_custom_domain_association.apprunner_custom_domain.certificate_validation_records)[0].name
  records         = [tolist(aws_apprunner_custom_domain_association.apprunner_custom_domain.certificate_validation_records)[0].value]
  ttl             = 300
  type            = tolist(aws_apprunner_custom_domain_association.apprunner_custom_domain.certificate_validation_records)[0].type
  zone_id         = data.aws_route53_zone.root_zone.zone_id
}

resource "aws_route53_record" "apprunner_acm_val_record1" {
  allow_overwrite = true
  name            = tolist(aws_apprunner_custom_domain_association.apprunner_custom_domain.certificate_validation_records)[1].name
  records         = [tolist(aws_apprunner_custom_domain_association.apprunner_custom_domain.certificate_validation_records)[1].value]
  ttl             = 300
  type            = tolist(aws_apprunner_custom_domain_association.apprunner_custom_domain.certificate_validation_records)[1].type
  zone_id         = data.aws_route53_zone.root_zone.zone_id
}
