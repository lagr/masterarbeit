angular.module 'WorkflowVersion'
.controller 'WorkflowVersionPageController', (tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)
  vm.workflow_version = pageData.workflow_version
  vm.setPageTitle(vm.workflow_version?.workflow?.name)

  vm.save = ->
    vm.stopEditing()

  vm.delete = ->
    vm.stopEditing()

  vm
