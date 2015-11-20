angular.module 'WFMS.WorkflowVersion'
.controller 'WorkflowVersionPageController', (tab, pageData, PageController, $mdToast) ->
  vm = new PageController(tab, pageData)
  
  pageData.workflow_version.then (workflowVersion) ->
    setWorkflowVersion(workflowVersion)

  vm.save = ->
    vm.workflowVersion.save()
      .then (workflowVersion) ->
        setWorkflowVersion(workflowVersion)
        vm.showToast('Workflow Version has been saved')

      .catch (response) ->
        vm.showToast('Error while saving Workflow Version')

  setWorkflowVersion = (workflowVersion) ->
    vm.workflowVersion = workflowVersion
    vm.setPageTitle(vm.workflowVersion.name)
    vm.stopEditing()

  vm
