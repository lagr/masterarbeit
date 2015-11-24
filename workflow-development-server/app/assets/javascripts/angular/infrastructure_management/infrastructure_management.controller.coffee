angular.module 'WFMS.Infrastructure'
.controller 'InfrastructureManagementPageController', (tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)
  vm.setPageTitle 'Infrastructure Management'

  pageData.servers.then (servers) ->
    vm.servers = servers

  pageData.repositories.then (repositories) ->
    vm.repositories = repositories

  vm
