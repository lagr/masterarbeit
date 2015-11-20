angular.module 'WFMS.Workflow'
.controller 'WorkflowsPageController', (tab, pageData, PageController, Workflows, tabManagement, $mdToast) ->
  vm = new PageController(tab, pageData)

  pageData.workflows.then (workflows) -> 
    vm.workflows = workflows 
  
  vm.setPageTitle 'Workflows'

  vm.createWorkflow = ->
    Workflows.create()
      .then (workflow) -> 
        tabManagement.openPage("Workflow", workflow.id)
        vm.showToast('Workflow has been created')

      .catch (response) ->
        vm.showToast('Error while creating Workflow')

  vm.deleteWorkflow = (workflow, event) ->
    event.stopPropagation()
    Workflows.delete(workflow)
      .then -> 
        _.remove(vm.workflows, workflow)
        vm.showToast('Workflow has been deleted')

      .catch ->
        vm.showToast('Error while deleting Workflow')

  vm
