param vnetName string = '${resourceGroup().name}-vnet1'
param vnetAddressPrefixNetwork string
param subnetCount int = 2
param nsgName string
param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
}

@batchSize(1)
resource vsubnets 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = [ for i in range (0, subnetCount): {
  name: '${vnetName}-${i}'
  parent: vnet
  properties: {
    addressPrefix: '${vnetAddressPrefixNetwork}${i}.0/24'
    networkSecurityGroup: {
      id: nsgName
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          location
        ]
      }]
  }
}]
