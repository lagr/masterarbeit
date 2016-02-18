angular.module 'WFMS.Workflow'
.controller 'WorkflowManagementController', (workflows, Workflow, $state) ->
  vm = @
  vm.workflows = workflows
  vm
