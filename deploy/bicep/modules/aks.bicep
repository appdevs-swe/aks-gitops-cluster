param name string
param nodeCount int = 3
param vmSize string = 'Standard_D4_v3'


var addonProfiles = {
  // gitops: {
  //   enabled: true
  // }
  // openServiceMesh : {
  //   enabled: true
  // }
}

resource aks 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: name
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: name
    enableRBAC: true
    kubernetesVersion: '1.23.5'
    addonProfiles: addonProfiles
    agentPoolProfiles: [
      {
        name: 'agentpool1'
        count: nodeCount
        vmSize: vmSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}

output name string = aks.name
