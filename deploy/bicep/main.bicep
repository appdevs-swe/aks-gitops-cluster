// Params
param aksName string = 'bg-gitops'
param location string = resourceGroup().location

//
// Top Level Resources
//


module aks 'modules/aks.bicep' = {
  name: aksName
  params: {
    name: aksName
    location: location
  }
}

// Outputs

output aksName string = aks.outputs.name


