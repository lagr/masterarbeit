angular.module 'WFMS.ProcessDesign'
.controller 'ProcessDesignerPageController', (tab, pageData, PageController, $mdToast) ->
  vm = new PageController(tab, pageData)
  
  pageData.workflow.then (workflow) ->
    setWorkflow(workflow)

  vm.save = ->
    vm.workflow.save()
      .then (workflow) ->
        setWorkflow(workflow)
        vm.showToast('Workflow has been saved')

      .catch (response) ->
        vm.showToast('Error while saving Workflow')

  setWorkflow = (workflow) ->
    vm.workflow = workflow
    vm.setPageTitle("#{vm.workflow.name} - #{vm.workflow.name}")
    vm.stopEditing()

  vm
