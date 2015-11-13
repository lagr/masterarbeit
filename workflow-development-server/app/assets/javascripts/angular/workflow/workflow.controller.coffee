angular.module 'Workflow'
.controller 'WorkflowPageController', (tab, pageData, PageController, $scope) ->
  vm = new PageController(tab, pageData)
  vm.workflow = pageData.workflow
  vm.setPageTitle(vm.workflow.name)
  vm
