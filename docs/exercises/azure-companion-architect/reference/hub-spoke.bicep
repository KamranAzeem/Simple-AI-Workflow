targetScope = 'resourceGroup'

@description('Azure region for all resources.')
param location string = resourceGroup().location

@description('Short suffix used in resource names.')
@minLength(3)
@maxLength(8)
@pattern('^[a-z0-9]+$')
param nameSuffix string

@description('Admin user name for both virtual machines.')
@minLength(1)
@maxLength(32)
param adminUsername string

@description('SSH public key for both virtual machines.')
@minLength(1)
param sshPublicKey string

@description('Spoke virtual machine size.')
param spokeVmSize string = 'Standard_B1s'

@description('Hub virtual machine size.')
param hubVmSize string = 'Standard_B1s'

var tags = {
  purpose: 'exercise'
  lab: '06'
}

var spokePrefix = 'spoke-${nameSuffix}'
var hubPrefix = 'hub-${nameSuffix}'
var cloudInit = '''#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
'''

resource spokeNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-${spokePrefix}'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowSSH'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'AllowHTTP'
        properties: {
          priority: 1010
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
        }
      }
    ]
  }
}

resource spokeVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-${spokePrefix}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
  }
}

resource spokeSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: spokeVnet
  name: 'workload'
  properties: {
    addressPrefix: '10.20.1.0/24'
    networkSecurityGroup: {
      id: spokeNsg.id
    }
  }
}

resource spokePublicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-${spokePrefix}'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource spokeNic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'nic-${spokePrefix}'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: spokeSubnet.id
          }
          publicIPAddress: {
            id: spokePublicIp.id
          }
        }
      }
    ]
  }
}

resource spokeStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'st${nameSuffix}s'
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

resource spokeVm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm-${spokePrefix}'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: spokeVmSize
    }
    osProfile: {
      computerName: 'spoke-${nameSuffix}'
      adminUsername: adminUsername
      customData: base64(cloudInit)
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: spokeNic.id
        }
      ]
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
  }
}

resource spokeBlobReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(spokeStorage.id, spokeVm.id, 'blob-reader')
  scope: spokeStorage
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
    principalId: spokeVm.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

resource spokeCpuAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'alert-cpu-${spokePrefix}'
  location: location
  tags: tags
  properties: {
    description: 'CPU above 80 percent for five minutes.'
    severity: 3
    enabled: true
    scopes: [
      spokeVm.id
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': '#Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'HighCpu'
          metricName: 'Percentage CPU'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    actions: []
  }
}

resource hubNsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-${hubPrefix}'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowSSHFromSpoke'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '10.20.0.0/16'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-${hubPrefix}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
  }
}

resource hubSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: hubVnet
  name: 'shared'
  properties: {
    addressPrefix: '10.30.1.0/24'
    networkSecurityGroup: {
      id: hubNsg.id
    }
  }
}

resource hubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: hubVnet
  name: 'hub-to-spoke'
  properties: {
    remoteVirtualNetwork: {
      id: spokeVnet.id
    }
  }
}

resource spokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: spokeVnet
  name: 'spoke-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
  }
}

resource hubNic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'nic-${hubPrefix}'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: hubSubnet.id
          }
        }
      }
    ]
  }
}

resource hubVm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm-${hubPrefix}'
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: hubVmSize
    }
    osProfile: {
      computerName: 'hub-${nameSuffix}'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: hubNic.id
        }
      ]
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
  }
}

output spokeVnetName string = spokeVnet.name
output hubVnetName string = hubVnet.name
output spokeVmName string = spokeVm.name
output hubVmName string = hubVm.name
output spokePublicIp string = spokePublicIp.properties.ipAddress
