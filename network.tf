# -----------------------------------------------------------------------
# VPC
# -----------------------------------------------------------------------

module "vpc" {
  source = "github.com/maxgio92/terraform-aws-vpc?ref=1.0.0"

  prefix_name                 = "${var.app_name}-${var.env_name}"
  vpc_cidr                    = "${var.network_cidr}"
  public_subnet_count         = "${var.network_public_subnet_count}"
  public_subnet_mask_newbits  = "${var.network_public_subnet_mask_newbits}"
  private_subnet_count        = "${var.network_private_subnet_count}"
  private_subnet_mask_newbits = "${var.network_private_subnet_mask_newbits}"
}
