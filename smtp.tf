data "aws_route53_zone" "selected" {
  name = "${var.app_dns_zone_name}"
}

module "smtp_server" {
  source = "github.com/maxgio92/terraform-ses?ref=1.0.1"

  domain  = "${var.app_dns_zone_name}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
}
