#= require_self
#= require ./dependencies
#= require_tree .

# fix incompability with new lodash version
_.contains = _.includes

angular.module 'WFMS.WorkflowDevelopmentApplication', [
  # helper modules
  'uuid4', 'restangular', 'ngMaterial', 'formly', 'ui.router',

  # topic modules
  'WFMS.ProcessDesign', 'WFMS.Dashboard', 'WFMS.Organization'
  ]

.controller 'ApplicationController', ($mdSidenav, $mdDialog) ->
  vm = @
  vm
