terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.41.0"
    }
  }
}
provider "azurerm"{
  features  {}
}
//terraform{
//backend "azurerm"{
    //resource_group_name = "mahaksiacrg"
    //storage_account_name = "mahaksiacstorageaccount"
    //container_name = "mahaksiaccontainer"
    //key = "terraform.tfstate"
//}
//}

resource "azurerm_resource_group" "resourcegroup" {
    name = "mahaksiacrg"
    location = "west us"
  
}
resource "azurerm_container_registry" "azurecontainerregistry" {
  name                     = "mahaksiacacr"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  sku                      = "Standard"
  admin_enabled            = true
}

resource "azurerm_app_service_plan" "serviceplan"{
    name = "mahaksiacaserviceplan"
    location = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name

    sku {
      tier = "Standard"
      size = "S1"
    }
  
}
resource "azurerm_app_service" "appservice" {
    name = "mahaksiacappservice"
    location = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name
    app_service_plan_id = azurerm_app_service_plan.serviceplan.id
  //site_config {
    //dotnet_framework_version = "v5.0"
    //always_on                = true
  

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"         = azurerm_container_registry.azurecontainerregistry.login_server
    "DOCKER_REGISTRY_SERVER_USERNAME"    = azurerm_container_registry.azurecontainerregistry.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"    = azurerm_container_registry.azurecontainerregistry.admin_password
    "WEBSITES_PORT"                      = "80"
  }

}