variable "apps" {
  description = "List of front end apps to deploy"
  type        = set(string)
}

variable "env" {
  description = "Environment to deploy the front end apps"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "infra_3_tier_webapp_aws_tf"
}
