resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}



# Red virtual 
resource "azurerm_virtual_network" "grupo5_terraform_network" {
  name                = "grupo5Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subred
resource "azurerm_subnet" "grupo5_terraform_subnet" {
  name                 = "grupo5Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.grupo5_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Ip Pública
resource "azurerm_public_ip" "grupo5_terraform_public_ip" {
  name                = "grupo5PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Grupo de seguridad y reglas de ingreso
resource "azurerm_network_security_group" "grupo5_terraform_nsg" {
  name                = "grupo5NetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

#Configuración para acceso vía ssh
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Interfaz de red
resource "azurerm_network_interface" "grupo5_terraform_nic" {
  name                = "grupo5NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "grupo5_nic_configuration"
    subnet_id                     = azurerm_subnet.grupo5_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.grupo5_terraform_public_ip.id
  }
}

# Asociar el grupo de seguridad con la interfaz de red
resource "azurerm_network_interface_security_group_association" "grupo5_NetworkInterface" {
  network_interface_id      = azurerm_network_interface.grupo5_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.grupo5_terraform_nsg.id
}

# Cuenta de almacenamiento y diagnosticos para la VM
resource "random_id" "random_id" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "grupo5_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Crear la clave ssh para acceder a la VM
resource "tls_private_key" "grupo5_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Crear la VM Linux
resource "azurerm_linux_virtual_machine" "grupo5_terraform_vm" {
  name                  = "grupo5VM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.grupo5_terraform_nic.id]
  size                  = "Standard_B2ms"

  os_disk {
    name                 = "grupo5OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "grupo5vm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.grupo5_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.grupo5_storage_account.primary_blob_endpoint
  }
}