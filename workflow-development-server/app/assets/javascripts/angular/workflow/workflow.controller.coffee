angular.module 'Workflow'
.controller 'WorkflowPageController', (tab, pageData, PageController, Workflows, $mdToast) ->
  vm = new PageController(tab, pageData)

  pageData.workflow.then (workflow) ->
    setWorkflow(workflow)

  vm.save = ->
    saveOperation = vm.workflow.save()
      .then (workflow) ->
        setWorkflow(workflow)
        $mdToast.simple().content('Workflow has been saved')

      .catch (response) ->
        $mdToast.simple().content('Error while saving workflow')

    saveOperation.then (toast) -> $mdToast.show(toast.position('top right'))

  setWorkflow = (workflow) ->
    vm.workflow = workflow
    vm.setPageTitle(vm.workflow.name)
    vm.stopEditing()

  vm
