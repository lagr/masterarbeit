#= require_self
#= require ./dependencies
#= require_tree .

angular.module 'WorkflowDevelopmentApplication', [
  # helper modules
  'uuid4', 'ui.router', 'ct.ui.router.extras', 'restangular'

  # custom helper modules
  'TabManagement',
  
  # topic modules
  'Dashboard', 'Workflow', 'Common', 'User'
  ]

.controller 'ApplicationController', (tabManagement) ->
  vm = @
  vm.tabManagement = tabManagement
  vm
