angular.module 'WorkflowVersion'
.controller 'WorkflowVersionPageController', (tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)

  vm.setPageTitle(pageData.workflow_version.workflow.name)
  vm.workflow_version = pageData.workflow_version

  vm.save = ->
    vm.stopEditing()

  vm.delete = ->
    vm.stopEditing()

  vm
