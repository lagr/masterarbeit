angular.module 'WFMS.Workflow'
.controller 'WorkflowPageController', (tab, pageData, PageController, tabManagement, Workflows, $mdToast) ->
  vm = new PageController(tab, pageData)

  pageData.workflow.then (workflow) ->
    setWorkflow(workflow)

  vm.save = ->
    vm.workflow.save()
      .then (workflow) ->
        setWorkflow(workflow)
        vm.showToast('Workflow has been saved')

      .catch (response) ->
        vm.showToast('Error while saving workflow')

  vm.delete = (event) ->
    Workflows.delete(vm.workflow)
      .then -> 
        tabManagement.openPage('Workflows')
        vm.showToast('Workflow has been deleted')

      .catch ->
        vm.showToast('Error while deleting Workflow')

  setWorkflow = (workflow) ->
    vm.workflow = workflow
    vm.setPageTitle(vm.workflow.name)
    vm.stopEditing()

  vm
