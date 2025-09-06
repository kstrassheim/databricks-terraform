resource "azurerm_resource_group" "databricks_rg" {
  name     = "rg-databricks"
  location = "West Europe"
}

# Create Databricks Workspace
resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = "dbw"
  resource_group_name = azurerm_resource_group.databricks_rg.name
  location            = azurerm_resource_group.databricks_rg.location
  sku                 = "premium"
  tags = {
    purpose     = "databricks-workspace"
  }
}

provider "databricks" {
  host = azurerm_databricks_workspace.databricks_workspace.workspace_url
}