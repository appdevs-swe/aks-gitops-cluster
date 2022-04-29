// Params
param aksName string = 'aks-bg-gitops'
param monitoringTool string = 'loganalytics'

//
// Top Level Resources
//


module aks 'modules/aks.bicep' = {
  name: aksName
  params: {
    name: aksName
    monitoringTool: monitoringTool
    logAnalyticsID: ''
  }
}

// Outputs

output aksName string = aks.outputs.name


