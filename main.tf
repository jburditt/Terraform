resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Static Web App

resource "azurerm_static_web_app" "static_web_app" {
  name                = var.static_web_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Custom Domain

resource "azurerm_dns_zone" "dns_zone" {
  name = var.domain
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_cname_record" "dns_zone" {
  name                = var.subdomain
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record              = azurerm_static_web_app.static_web_app.default_host_name
}

resource "azurerm_static_web_app_custom_domain" "static_web_app" {
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name       = "${azurerm_dns_cname_record.gamifyworkout.name}.${azurerm_dns_cname_record.gamifyworkout.zone_name}"
  validation_type   = "cname-delegation"
}
