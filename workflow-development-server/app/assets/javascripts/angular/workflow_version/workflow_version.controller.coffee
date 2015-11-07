angular.module 'WorkflowVersion'
.controller 'WorkflowVersionPageController', (tab, pageData, PageController) ->
  controller = new PageController(tab, pageData)
  controller.setPageTitle pageData.workflow_version.workflow.name
  controller
