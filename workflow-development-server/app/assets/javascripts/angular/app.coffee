#= require_self
#= require ./dependencies
#= require_tree .

angular.module 'WorkflowDevelopmentApplication', [
  # helper modules
  'uuid4', 'ui.router', 'ct.ui.router.extras', 'restangular', 'ngMaterial', 'formly'

  # custom helper modules
  'TabManagement',
  
  # topic modules
  'Dashboard', 'Workflow', 'WorkflowVersion', 'Common', 'User', 'ProcessDesign'
  ]

.controller 'ApplicationController', (tabManagement) ->
  vm = @
  vm.tabManagement = tabManagement
  vm
