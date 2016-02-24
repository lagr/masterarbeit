#= require_self
#= require ./dependencies
#= require_tree .

# fix incompability with new lodash version
_.contains = _.includes

angular.module 'WFMS.WorkflowDevelopmentApplication', [
  # helper modules
  'uuid4', 'ngMaterial', 'formly', 'ui.router', 'rails', 'ng.jsoneditor',
  'WFMS.Dashboard', 'WFMS.Organization', 'WFMS.Workflow', 'WFMS.Infrastructure', 'WFMS.ProcessDefinition'
]

.controller 'ApplicationController', ($mdSidenav, $mdDialog) ->
  vm = @
  vm
