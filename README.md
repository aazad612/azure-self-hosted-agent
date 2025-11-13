# How to setup Azure DevOps (Ubuntu) Agent for self hosted or custom agent. 

While the script of importance for everyone would be the cloud-init.yml.tmpl which configures the virtual machine and should be reused, if you are complete beginner the scripts in this repo can setup a self hosted agent pool in an actual workplace like setup.

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

