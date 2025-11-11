#############################
# Core Azure configuration
#############################

variable "resource_group_name" {
  description = "Existing resource group to host the agent VM and networking"
  type        = string
}

variable "location" {
  description = "Azure region (e.g., eastus, westus2)"
  type        = string
}

#############################
# Networking configuration
#############################

variable "vnet_address_space" {
  description = "VNet address space (e.g., [\"10.42.0.0/16\"])"
  type        = list(string)
}

variable "subnet_address_prefixes" {
  description = "Subnet prefixes (e.g., [\"10.42.1.0/24\"])"
  type        = list(string)
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR form for SSH allowlist (e.g., 12.34.56.78/32)"
  type        = string
}

#############################
# VM configuration
#############################

variable "vm_name" {
  description = "Virtual machine name (also used in resource naming)"
  type        = string
}

variable "vm_size" {
  description = "Azure VM size (e.g., Standard_B2s)"
  type        = string
}

variable "admin_username" {
  description = "Admin username for SSH access"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Absolute or ~-expanded path to your SSH public key"
  type        = string
}

variable "agent_version" {
  description = "Azure DevOps agent version to install (e.g., 3.234.1)"
  type        = string
}

#############################
# Azure DevOps configuration
#############################

variable "ado_org_url" {
  description = "Azure DevOps organization URL (e.g., https://dev.azure.com/yourorg)"
  type        = string
}

variable "ado_pat" {
  description = "Azure DevOps Personal Access Token with 'Agent Pools (Read & manage)' permissions"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Azure DevOps project to authorize the pool for"
  type        = string
}

variable "agent_pool_name" {
  description = "Self-hosted agent pool name to create/use"
  type        = string
}

#############################
# Common tags
#############################

variable "tags" {
  description = "Common tags to apply to all Azure resources"
  type        = map(string)
}


variable "storage_account_name" {
  description = "Globally unique name for the Azure Storage Account (3-24 lowercase alphanumeric)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 chars, lowercase letters and digits only."
  }
}

variable "storage_account_tier" {
  description = "Storage account performance tier (Standard or Premium)."
  type        = string

  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "storage_account_tier must be either Standard or Premium."
  }
}

variable "storage_replication_type" {
  description = "Replication type for the storage account (LRS, ZRS, GRS, or RAGRS)."
  type        = string

  validation {
    condition     = contains(["LRS", "ZRS", "GRS", "RAGRS"], var.storage_replication_type)
    error_message = "storage_replication_type must be one of LRS, ZRS, GRS, or RAGRS."
  }
}