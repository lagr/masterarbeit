angular.module 'WFMS.Workflow'
.controller 'WorkflowController', (workflow) ->
  vm = @
  vm.workflow = workflow

  vm.saveWorkflow = -> vm.workflow.save()
  vm.deleteWorkflow = -> vm.workflow.delete()
  vm
