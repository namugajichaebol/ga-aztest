// Bicep for Virtual Network
param vnetIndex int = 1
param vnetName string = 'vnet-namugaji${vnetIndex}'
param location string = resourceGroup().location
@allowed(['16'])
param vnetAddressPrefixCIDR string = '16'
param vnetAddressPrefix string = '10.${vnetIndex}.0.0/${vnetAddressPrefixCIDR}'
@minValue(1)
// Subnet 200+ are reserveded, and will not be subject to default configurations (e.g. peering and default nsg association)
@maxValue(199)
param subnetCount int = 2


var vnetAddressPrefixArray = split(vnetAddressPrefix, '.')
var vnetAddressPrefixNetwork = '${vnetAddressPrefixArray[0]}.${vnetAddressPrefixArray[1]}.'
var nsgDefaultName  = 'nsg-vnet${vnetIndex}-default'

@description('Determine if vnet0 exists')
resource sVnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
    name: hubvnetName
}
var resourceVnetExists = contains(sVnet.id, hubvnetName)

resource nsgDefaultName_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: nsgDefaultName
  location: location
  properties: {
    securityRules: []
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
    name: vnetName
    location: location
    properties: {
        addressSpace: {
            addressPrefixes: [
                vnetAddressPrefix
            ]
        }
    }
}

module subnetModule 'modules/subnets.bicep' = {
    name: 'subnetModule'
    params: {
        vnetName: vnetName
        vnetAddressPrefixNetwork: vnetAddressPrefixNetwork
        subnetCount: subnetCount
        location: location
        nsgName: nsgDefaultName_resource.id
    }
    dependsOn: [
      vnet
    ]
}
