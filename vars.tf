variable "aws_region" {
  default = "eu-central-1"
}

variable "environment" {
  default = "example"
}

variable "domain" {
  default = "webster"
}

variable "name" {
  default = "cognito_app"
}

variable "client_django_callback" {
  default = "http://localhost:8000/accounts/amazon-cognito/login/callback/"
}

variable "client_drf_callback" {
  default = "http://localhost:8000/oauth/callback/"
}
