angular.module 'Workflow'
.controller 'WorkflowsPageController', (tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)
  console.log pageData
  vm.workflows = pageData.workflows
  vm.setPageTitle 'Workflows'

  vm
