#= require_self
#= require ./dependencies
#= require_tree .

angular.module 'WFMS.WorkflowDevelopmentApplication', [
  # helper modules
  'uuid4', 'ui.router', 'ct.ui.router.extras', 'restangular', 'ngMaterial', 'formly'

  # custom helper modules
  'WFMS.TabManagement',
  
  # topic modules
  'WFMS.Common', 
  'WFMS.Dashboard',  
  'WFMS.Infrastructure',  
  'WFMS.ProcessDesign' 
  'WFMS.User',  
  'WFMS.Workflow',  
  'WFMS.WorkflowBundle', 
  ]

.controller 'ApplicationController', (tabManagement) ->
  vm = @
  vm.tabManagement = tabManagement
  vm
