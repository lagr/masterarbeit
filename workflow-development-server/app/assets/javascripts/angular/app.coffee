#= require_self
#= require ./dependencies
#= require_tree .

angular.module 'WorkflowDevelopmentApplication', [
  # helper modules
  'uuid4',

  # routing related
  'ui.router', 'ct.ui.router.extras', 

  # custom helper modules
  'TabManagement',
  
  # topic modules
  'Dashboard', 'Workflows'
  ]

.controller 'ApplicationController', (tabManagement) ->
  vm = @
  vm.tabManagement = tabManagement
  vm
