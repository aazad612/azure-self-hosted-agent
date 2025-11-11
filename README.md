# Azure DevOps Self-Hosted Agent (Ubuntu) Setup Guide

This guide walks through provisioning an Azure VM and configuring it as a self-hosted Azure DevOps agent.  
It assumes:
- You have an Azure subscription
- You already have an Azure DevOps organization (e.g. `https://dev.azure.com/aazadsgcp`)

---

## Software install ( Azure CLI, GIT, Terraforn)

Open **PowerShell (Admin)**  

```powershell
winget install --id Microsoft.AzureCLI -e
az --version

winget install --id HashiCorp.Terraform -e
terraform -version

winget install --id Git.Git -e
git --version
```

## Verify everything is working in bash

```bash
# azuze cli
az login 

az account list --output table

az account set --subscription "devops_gcp"

az account show --output table

# GIT 
git config --global user.name "Johney Aazad"
git config --global user.email "johney@aazads.us"
git config --list
git config --global credential.helper manager

mkdir c:\work
cd c:\work 

git clone https://github.com/aazad612/azure-self-hosted-agent.git

cd azure-self-hosted-agent

# SSH Keys 
ssh-keygen -t rsa -b 4096 -C "johney@aazads.us" -f ~/.ssh/computevm-test

# Terraform  
terraform init
terraform plan
terraform apply 

# To recreate just the VM in case of failures
terraform apply -replace=azurerm_linux_virtual_machine.vm -auto-approve

# Connect to VM to debug (IP will be output from the terraform apply above)
ssh -i ~/.ssh/computevm azureadmin@222.22.22.22

cat /var/log/ado_install.log

```


# Helpers and debugging 
Please add these to your .bash_profile

```bash 
# go ot your home folder
cd ~
vi .bash_profile

# Terraform helpers 
alias tfmt="terraform fmt"
alias tfa="terraform apply -auto-approve"
alias tfp="terraform plan"
alias tfi="terraform init"
alias tfd="terraform destroy -auto-approve"
```

