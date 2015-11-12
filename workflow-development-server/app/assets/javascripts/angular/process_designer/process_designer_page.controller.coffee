angular.module 'ProcessDesign'
.controller 'ProcessDesignerPageController', (tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)
  vm.workflow_version = pageData.workflow_version
  
  vm.setPageTitle "Design: #{vm.workflow_version.workflow.name}"

  vm
