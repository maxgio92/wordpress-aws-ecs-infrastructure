terraform {
  backend "s3" {
    bucket         = "wordpress-aws-ecs-infrastructure.tfstate.d"
    dynamodb_table = "wordpress-aws-ecs-infrastructure.tfstate.d"
    key            = "state/key"
    region         = "eu-west-1"
  }
}
