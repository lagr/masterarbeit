angular.module 'Workflow'
.controller 'WorkflowsPageController', (tab, pageData, PageController, Workflows, tabManagement, $mdToast) ->
  vm = new PageController(tab, pageData)

  pageData.workflows.then (workflows) -> 
    vm.workflows = workflows 
  
  vm.setPageTitle 'Workflows'

  vm.createWorkflow = ->
    createOperation = Workflows.create()
      .then (workflow) -> 
        tabManagement.openPage("Workflow", workflow.id)
        $mdToast.simple().content('Workflow Version has been created')

      .catch (response) ->
        $mdToast.simple().content('Error while creating Workflow Version')

    createOperation.then (toast) -> $mdToast.show(toast.position('top right'))

  vm.deleteWorkflow = (workflow, event) ->
    event.stopPropagation()
    deleteOperation = Workflows.delete(workflow)
      .then -> 
        _.remove(vm.workflows, workflow)
        $mdToast.simple().content('Workflow Version has been deleted')

      .catch ->
        $mdToast.simple().content('Error while deleting Workflow Version')

    deleteOperation.then (toast) -> $mdToast.show(toast.position('top right'))

  vm
