module "audit-log" {
    source = "../audit-log"    
    gcp_project = var.gcp_project    
}

output "log_service_account_id" {
  value = module.audit-log.log_service_account_out
}