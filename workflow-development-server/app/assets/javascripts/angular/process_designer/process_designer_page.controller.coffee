angular.module 'WFMS.ProcessDesign'
.controller 'ProcessDesignerPageController', (tab, pageData, PageController, $mdToast) ->
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
    vm.setPageTitle("#{vm.workflowVersion.workflow.name} - #{vm.workflowVersion.name}")
    vm.stopEditing()

  vm
