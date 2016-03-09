angular.module 'WFMS.Workflow'
.controller 'WorkflowManagementController', (workflows, Workflow, $state) ->
  vm = @
  vm.workflows = workflows
  vm.createWorkflow = ->
    wf = new Workflow(name: 'unnamed')
    wf.create().then ->
      wf.get().then (newWf) ->
        $state.go 'app.workflow_management.workflow', { workflow_id: newWf.id }, reload: true
  vm
