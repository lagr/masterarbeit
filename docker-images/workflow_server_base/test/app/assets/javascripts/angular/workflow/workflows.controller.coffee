angular.module 'Workflow'
.controller 'WorkflowsPageController', (tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)

  pageData.workflows.then (workflows) -> 
    vm.workflows = workflows 
  
  vm.setPageTitle 'Workflows'

  vm
