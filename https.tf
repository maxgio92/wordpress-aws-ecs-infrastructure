# -----------------------------------------------------------------------
# DNS endpoint
# -----------------------------------------------------------------------

resource "aws_route53_record" "app" {
  count = "${length(var.app_domain_names)}"

  name = "${element(var.app_domain_names, count.index)}"
  type = "A"

  alias {
    name                   = "${module.public_lb.dns_name}"
    zone_id                = "${module.public_lb.zone_id}"
    evaluate_target_health = false
  }

  zone_id = "${data.aws_route53_zone.app.id}"
}

# -----------------------------------------------------------------------
# TLS certificate
# -----------------------------------------------------------------------

# ACM certificate

resource "aws_acm_certificate" "app" {
  domain_name               = "${element(var.app_domain_names, 0)}"
  subject_alternative_names = "${slice(var.app_domain_names, 1, length(var.app_domain_names))}"
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation

data "aws_route53_zone" "app" {
  name = "${var.app_dns_zone_name}"
}

resource "aws_route53_record" "app_tls_certificate_validation" {
  count = "${length(var.app_domain_names)}"

  name    = "${lookup(aws_acm_certificate.app.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.app.domain_validation_options[count.index], "resource_record_type")}"
  records = ["${lookup(aws_acm_certificate.app.domain_validation_options[count.index], "resource_record_value")}"]

  zone_id = "${data.aws_route53_zone.app.id}"

  ttl = 300
}

resource "aws_acm_certificate_validation" "app" {
  certificate_arn         = "${aws_acm_certificate.app.arn}"
  validation_record_fqdns = ["${aws_route53_record.app_tls_certificate_validation.*.fqdn}"]
}
