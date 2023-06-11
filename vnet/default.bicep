// Bicep for Virtual Network
param vnetIndex int = 0
param vnetName string = '${resourceGroup().name}-vnet${vnetIndex}'
param location string = resourceGroup().location
@allowed(['16'])
param vnetAddressPrefixCIDR string = '16'
param vnetAddressPrefix string = '10.${vnetIndex}.0.0/${vnetAddressPrefixCIDR}'
@minValue(1)
// Subnet 200+ are reserveded, and will not be subject to default configurations (e.g. peering and default nsg association)
@maxValue(199)
param subnetCount int = 2
@description('Bool variable to peer to vnet0')
param deployPeering2vnet0  bool = true
@description('Bool variable to deploy bastion, if deploying vnet0')
param deployBastionOnvnet0 bool = false
param deployFwOnvnet0 bool = true

var vnetAddressPrefixArray = split(vnetAddressPrefix, '.')
var vnetAddressPrefixNetwork = '${vnetAddressPrefixArray[0]}.${vnetAddressPrefixArray[1]}.'
var bastionAddressPrefixNetwork  = '${vnetAddressPrefixNetwork}254'
var fwAddressPrefixNetwork  = '${vnetAddressPrefixNetwork}255'
var hubvnetName = '${resourceGroup().name}-vnet0'
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

module fwModule 'modules/firewall.bicep' = if (deployFwOnvnet0 && !(bool(vnetIndex))) {
    name: 'fwModule'
    params: {
      vnetName: vnetName
      subnetAddressPrefixNetwork: fwAddressPrefixNetwork 
      location: location
    }
    dependsOn: [
      subnetModule
    ]
}

module bastionModule 'modules/bastion.bicep' = if (deployBastionOnvnet0 && !(bool(vnetIndex))) {
    name: 'bastionModule'
    params: {
      vnetName: vnetName
      subnetAddressPrefixNetwork: bastionAddressPrefixNetwork 
      location: location
    }
    dependsOn: [
      subnetModule
    ]
}

module peeringModule 'modules/peering.bicep' = if (resourceVnetExists && deployPeering2vnet0 && bool(vnetIndex)) {
    name: 'peeringModule'
    params: {
        sVnetName: hubvnetName
        dVnetName: vnetName
    }
    dependsOn: [
      subnetModule
    ]
}
