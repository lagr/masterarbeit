angular.module 'Workflow'
.controller 'WorkflowPageController', (tab, pageData, PageController) ->
  controller = new PageController(tab, pageData)
  controller.pageData = pageData
  controller
