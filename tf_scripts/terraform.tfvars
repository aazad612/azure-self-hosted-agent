
# RESOURCE GROUP
# resource_group_name     = "rg-aazads-devops"
resource_group_name     = "rg-aazads-org"
location                = "eastus"

# AZURE DEVOPS
ado_org_url             = "https://dev.azure.com/aazadsgcp"
project_name            = "gcp_bootstrap"
agent_pool_name         = "AzureVM"

# NETWORK 
vnet_address_space      = ["10.42.0.0/16"]
subnet_address_prefixes = ["10.42.1.0/24"]


# AGENT VM
vm_name                 = "ado-agent-1"
vm_size                 = "Standard_B2s"
admin_username          = "azureadmin"
ssh_public_key_path     = "~/.ssh/computevm.pub"
agent_version           = "3.236.0"


# STORAGE ACCOUNT - OPTIONAL
storage_account_name       = "saaazadsdevops"
storage_account_tier       = "Standard"
storage_replication_type   = "LRS"

# TAGS 
tags = {
  owner   = "johney"
  purpose = "ado-self-hosted-agent"
}



