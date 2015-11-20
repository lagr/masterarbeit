angular.module 'WFMS.WorkflowBundle'
.controller 'WorkflowBundlePageController', (tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)
  vm.workflowBundle = pageData.workflow_bundle
  vm.setPageTitle(vm.workflowBundle.name)
  vm
