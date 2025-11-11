locals {
  cloud_init = templatefile("${path.module}/cloud-init.yml.tmpl", {
    agent_version   = var.agent_version
    ado_org_url     = var.ado_org_url
    agent_pool_name = var.agent_pool_name
    vm_name         = var.vm_name
    ado_pat         = var.ado_pat
    admin_username  = var.admin_username
    ssh_public_key_path = var.ssh_public_key_path
  })
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = local.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 64
  }

  # SSH key for ${var.admin_username}
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  # Ubuntu 22.04 LTS
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Ensure the DevOps pool/queue exist before the VM bootstraps the agent
  depends_on = [
    azuredevops_agent_pool.pool,
    azuredevops_agent_queue.queue
  ]

  # IMPORTANT: custom_data must be base64-encoded
  custom_data = base64encode(local.cloud_init)

  tags = var.tags
}
