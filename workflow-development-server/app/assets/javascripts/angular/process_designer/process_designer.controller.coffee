angular.module 'ProcessDesigner'
.controller 'ProcessDesignerPageController', (tab, pageData, PageController) ->
  controller = new PageController(tab, pageData)
  controller.setPageTitle "Design: #{pageData.workflow_version.workflow.name}"
  controller
