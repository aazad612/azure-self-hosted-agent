output "agent_public_ip" {
  value       = azurerm_public_ip.pip.ip_address
  description = "Public IP of the agent VM"
}

output "ssh" {
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.pip.ip_address}"
  description = "SSH command"
}

output "pool_reminder" {
  value       = "Ensure your project's Build Service has 'Service Account' on pool '${var.agent_pool_name}'."
  description = "Pool permission reminder"
}
