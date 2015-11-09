angular.module 'Workflow'
.controller 'WorkflowsPageController', (tab, pageData, PageController) ->
  controller = new PageController(tab, pageData)
  controller.workflows = pageData.workflows
  controller.setPageTitle 'Workflows'
  controller
