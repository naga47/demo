
// Define parameters to make the template configurable
param location string = 'East US'
param storageAccountName string
param storageAccountSku string = 'Standard_LRS'

// Declare a variable to store resource group name
var resourceGroupName = 'myResourceGroup'

// Define a resource for an Azure Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
}

// Create an Azure Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2018-05-01' = {
  name: resourceGroupName
  location: location
}

// Define an output to display storage account connection string
output storageAccountConnectionString string = storageAccount.properties.primaryEndpoints.blob

// Define a custom module for a virtual network
module virtualNetwork 'myModules/virtualNetwork.bicep' = {
  name: 'myVirtualNetwork'
  params: {
    location: location
    vnetName: 'myVNet'
    addressPrefix: '10.0.0.0/16'
  }
}

// Use a function to generate a unique name
var uniqueName = '${resourceGroupName}-${storageAccountName}-${uniqueString(resourceGroup().id)}'

// Create an output that combines variable and parameter values
output resourceDetails string = '${location} | ${storageAccountName} | ${uniqueName}'
