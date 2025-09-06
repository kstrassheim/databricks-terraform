# Create Resource Group

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

# Get current user/client information
data "azurerm_client_config" "current" {}

# Create Azure AD Security Group for Databricks access
# resource "azuread_group" "databricks_users" {
#   display_name     = "Databricks-Users-${var.environment}"
#   description      = "Security group for Databricks workspace users in ${var.environment} environment"
#   security_enabled = true
  
#   # Add owners (optional)
#   owners = [data.azurerm_client_config.current.object_id]
# }

# # Create Azure AD Security Group for Databricks admins
# resource "azuread_group" "databricks_admins" {
#   display_name     = "Databricks-Admins-${var.environment}"
#   description      = "Security group for Databricks workspace administrators in ${var.environment} environment"
#   security_enabled = true
  
#   # Add owners (optional)
#   owners = [data.azurerm_client_config.current.object_id]
# }

# # Add current user to the admin group
# resource "azuread_group_member" "current_user_admin" {
#   group_object_id  = azuread_group.databricks_admins.id
#   member_object_id = data.azurerm_client_config.current.object_id
# }

# Assign Contributor role to Databricks Users group on the workspace
# resource "azurerm_role_assignment" "databricks_users_contributor" {
#   scope                = azurerm_databricks_workspace.databricks_workspace.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_group.databricks_users.id
# }

# Assign Owner role to Databricks Admins group on the workspace
# resource "azurerm_role_assignment" "databricks_admins_owner" {
#   scope                = azurerm_databricks_workspace.databricks_workspace.id
#   role_definition_name = "Owner"
#   principal_id         = azuread_group.databricks_admins.id
# }

# Configure Databricks provider


# # Add current user as admin to Databricks workspace
# resource "databricks_user" "current_user" {
#   user_name    = "service-principal-${data.azurerm_client_config.current.client_id}"
#   display_name = "Current User"
  
#   depends_on = [azurerm_databricks_workspace.databricks_workspace]
# }

# # Grant workspace permissions to groups
# resource "databricks_permissions" "workspace_permissions" {
#   directory_path = "/"
#   access_control {
#     group_name       = databricks_group.workspace_users.display_name
#     permission_level = "CAN_MANAGE"
#   }

#   access_control {
#     group_name       = databricks_group.workspace_users.display_name
#     permission_level = "CAN_MANAGE"
#   }
#   depends_on = []
# }

# # Add new outputs for user permissions
# output "current_user_object_id" {
#   description = "Object ID of the current user"
#   value       = data.azurerm_client_config.current.object_id
# }

# output "databricks_user_id" {
#   description = "Databricks user ID"
#   value       = databricks_user.current_user.id
# }




# # # Create Databricks groups (inside the workspace)
# resource "databricks_group" "workspace_users" {
#   display_name = "workspace-users"
  
#   depends_on = [azurerm_databricks_workspace.databricks_workspace]
# }

# resource "databricks_group" "workspace_admins" {
#   display_name = "workspace-admins"
  
#   depends_on = [azurerm_databricks_workspace.databricks_workspace]
# }

# # Also add the current user to the workspace admin group
# resource "databricks_group_member" "current_user_workspace_admin" {
#   group_id  = databricks_group.workspace_admins.id
#   member_id = databricks_user.current_user.id
# }