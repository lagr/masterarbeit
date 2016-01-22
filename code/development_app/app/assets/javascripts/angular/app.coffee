#= require_self
#= require ./dependencies
#= require_tree .

angular.module 'WFMS.WorkflowDevelopmentApplication', [
  # helper modules
  'uuid4', 'restangular', 'ngMaterial', 'formly', 'ui.router',

  # topic modules
  'WFMS.ProcessDesign'
  ]

.controller 'ApplicationController', () ->
  vm = @
  vm
