terraform {
  required_version = ">= 1.9.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.37.1"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
  }
}
