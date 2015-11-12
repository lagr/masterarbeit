angular.module 'Workflow'
.controller 'WorkflowPageController', (tab, pageData, PageController, $scope) ->
  controller = new PageController(tab, pageData)
  controller.workflow = pageData.workflow
  controller.setPageTitle pageData.workflow.name
  controller
