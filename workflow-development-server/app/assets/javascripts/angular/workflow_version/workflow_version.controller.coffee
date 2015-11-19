angular.module 'WorkflowVersion'
.controller 'WorkflowVersionPageController', (tab, pageData, PageController, $mdToast) ->
  vm = new PageController(tab, pageData)
  
  pageData.workflow_version.then (workflowVersion) ->
    setWorkflowVersion(workflowVersion)

  vm.save = ->
    saveOperation = vm.workflowVersion.save()
      .then (workflowVersion) ->
        setWorkflowVersion(workflowVersion)
        $mdToast.simple().content('Workflow Version has been saved')

      .catch (response) ->
        $mdToast.simple().content('Error while saving Workflow Version')

    saveOperation.then (toast) -> $mdToast.show(toast.position('top right'))

  setWorkflowVersion = (workflowVersion) ->
    vm.workflowVersion = workflowVersion
    vm.setPageTitle(vm.workflowVersion.name)
    vm.stopEditing()

  vm
