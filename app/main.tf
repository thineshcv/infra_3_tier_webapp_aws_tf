module "frontend_buckets" {
  source  = "../modules/s3_with_clodfront"
  project = var.project
  env     = var.env
  apps = ["micro-frontend-1", "micro-frontend-2", "micro-frontend-3"]
}
