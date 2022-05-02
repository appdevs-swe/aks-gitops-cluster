// Params
param aksName string = 'bg-gitops'

//
// Top Level Resources
//


module aks 'modules/aks.bicep' = {
  name: aksName
  params: {
    name: aksName
  }
}

// Outputs

output aksName string = aks.outputs.name


