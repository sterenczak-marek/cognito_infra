provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_cognito_user_pool" "pool" {
  name = "${var.environment}_${var.name}"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 2048
    }
  }

  tags = {
    "Name"    = "${var.environment}"
    "Project" = "${var.name}"
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.domain}"
  user_pool_id = "${aws_cognito_user_pool.pool.id}"
}

resource "aws_cognito_user_pool_client" "client_django" {
  name = "${var.environment}_${var.name}_client_django"

  user_pool_id = "${aws_cognito_user_pool.pool.id}"

  generate_secret                      = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = ["${var.client_django_callback}"]
}

resource "aws_cognito_user_pool_client" "client_drf" {
  name = "${var.environment}_${var.name}_client_drf"

  user_pool_id = "${aws_cognito_user_pool.pool.id}"

  generate_secret                      = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = ["${var.client_drf_callback}"]
}
