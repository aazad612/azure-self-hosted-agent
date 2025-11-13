# Azure DevOps (Ubuntu) Agent — Production-Grade, Cloud-Init Driven

This guide shows you how to build a real workplace-grade Azure DevOps self-hosted (custom) Linux agent, the way it’s done in professional environments:

- Fully automated provisioning using Terraform
- Zero manual SSH setup
- Cloud-init based bootstrapping that configures everything at first boot
- Idempotent, reproducible, infrastructure-as-code

**If you are new to Azure DevOps, you can still follow along. But if you already work with AWS or GCP and want to do DevOps on Azure the “proper” way, this repo is built for you.**

## These scripts automate the entire lifecycle of a production-ready DevOps agent:

- Creates an Azure VM
- Configures networking
- Sets up an Azure DevOps agent pool
- Passes all configuration to the VM using cloud-init
    - Azure CLI
    - Google Cloud SDK
    - Agent installation
    - Automatic service setup
    - Agent registration to Azure DevOps
    - Instrumentation, logging, corrective flows
    - Fully idempotent behavior
    - Safe retries + safe cleanup


## Prerequisites 
- Azure subscription and an empty resource group.
- Azure DevOps organization (e.g. `https://dev.azure.com/aazadsgcp`)
- Softwares Installed 
    * Azure-CLI
    * GIT 
    * Terraform

## Steps

Please use GITBASH on windows or ITERM on Mac

```bash
mkdir /mnt/c/work
cd /mnt/c/work 

# azuze cli
az login 
az account list --output table

az account set --subscription "devops_gcp"
az account show --output table

az group create --name rg-aazads-org --location eastus

git clone https://github.com/aazad612/azure-self-hosted-agent.git

cd azure-self-hosted-agent

# SSH Keys 
ssh-keygen -t rsa -b 4096 -C "johney@aazads.us" -f ~/.ssh/computevm
```

## Update TFVARS and Create a PAT 
Create a personal access token in azure devops org 
https://dev.azure.com/aazadsgcp/_usersSettings/tokens

create a file called sensitive.auto.tfvars and populate it with the below 2 values. 

```
ado_pat = <your personal access token>
my_ip_cidr = <your ip address/32>
```

## Terraform apply 

```bash
# Terraform  
terraform init
terraform plan
terraform apply 

# To recreate just the VM in case of failures
terraform apply -replace=azurerm_linux_virtual_machine.vm -auto-approve

# Connect to VM to debug (IP will be output from the terraform apply above)
ssh -i ~/.ssh/computevm azureadmin@172.173.222.80

cat /var/log/ado_install.log

```


# Helpers and debugging for beginners 
Please add these to your .bash_profile

## Software install ( Azure CLI, GIT, Terraforn)

Open **PowerShell (Admin)**  

```powershell
winget install --id Microsoft.AzureCLI --scope user
az --version

winget install --id HashiCorp.Terraform --scope user
terraform -version

winget install --id Git.Git --scope user
git --version

# GIT 
git config --global user.name "Johney Aazad"
git config --global user.email "johney@aazads.us"
git config --list
git config --global credential.helper manager

```

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

