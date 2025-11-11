data "azuredevops_project" "proj" {
  name = var.project_name
}

resource "azuredevops_agent_pool" "pool" {
  name           = var.agent_pool_name
  auto_provision = false
  auto_update    = true
}

resource "azuredevops_agent_queue" "queue" {
  project_id    = data.azuredevops_project.proj.id
  agent_pool_id = azuredevops_agent_pool.pool.id
}
