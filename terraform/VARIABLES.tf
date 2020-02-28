variable "az_subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "az_client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "az_client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "az_tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}

variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
}