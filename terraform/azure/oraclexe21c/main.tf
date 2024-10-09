data "template_file" "default" {
  template = file("./utils/instance.sh")
  vars = {
    compute_user = "${var.vm_user}"
    cdc_url = "${var.confluentcdcsetup}"
  }
}


resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg_cdc_workshop" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

# Create virtual network
resource "azurerm_virtual_network" "cdc_workshop_terraform_network" {
  name                = "CDCWorkshopVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_cdc_workshop.location
  resource_group_name = azurerm_resource_group.rg_cdc_workshop.name
}

# Create subnet
resource "azurerm_subnet" "cdc_workshop_terraform_subnet" {
  name                 = "cdcworkshopSubnet"
  resource_group_name  = azurerm_resource_group.rg_cdc_workshop.name
  virtual_network_name = azurerm_virtual_network.cdc_workshop_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "cdc_workshop_terraform_public_ip" {
  name                = "CDCWorkshopPublicIP"
  location            = azurerm_resource_group.rg_cdc_workshop.location
  resource_group_name = azurerm_resource_group.rg_cdc_workshop.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "cdc_workshop_terraform_nsg" {
  name                = "CDCWorkshopNetworkSecurityGroup"
  location            = azurerm_resource_group.rg_cdc_workshop.location
  resource_group_name = azurerm_resource_group.rg_cdc_workshop.name

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
  security_rule {
    name                       = "Oracle"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1521"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "cdc_workshop_terraform_nic" {
  name                = "CDCWorkshopNIC"
  location            = azurerm_resource_group.rg_cdc_workshop.location
  resource_group_name = azurerm_resource_group.rg_cdc_workshop.name

  ip_configuration {
    name                          = "cdc_workshop_nic_configuration"
    subnet_id                     = azurerm_subnet.cdc_workshop_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cdc_workshop_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.cdc_workshop_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.cdc_workshop_terraform_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg_cdc_workshop.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "cdc_workshop_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg_cdc_workshop.location
  resource_group_name      = azurerm_resource_group.rg_cdc_workshop.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "cdc_workshop_terraform_oracle" {
  name                  = "CDCWorkshopOracle21c"
  location              = azurerm_resource_group.rg_cdc_workshop.location
  resource_group_name   = azurerm_resource_group.rg_cdc_workshop.name
  network_interface_ids = [azurerm_network_interface.cdc_workshop_terraform_nic.id]
  size                  = "Standard_DS2_v2" # 2 vCPUs 7 GB Memory
  computer_name         = "oracle21c"
  admin_username        = var.vm_user
  user_data             = base64encode(data.template_file.default.rendered)

  os_disk {
    name                 = "CDCWorkshopOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
    
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8-lvm-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "${var.vm_user}"
    public_key = file("${var.publicsshkey}")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.cdc_workshop_storage_account.primary_blob_endpoint
  }

  provisioner "local-exec" {
    command = "bash ./00_create_client.properties.sh ${azurerm_linux_virtual_machine.cdc_workshop_terraform_oracle.public_ip_address}"
    when = create
  }
}