angular.module 'WFMS.Infrastructure'
.controller 'InfrastructureManagementPageController', (Server, tab, pageData, PageController) ->
  vm = new PageController(tab, pageData)
  vm.setPageTitle 'Infrastructure Management'

  pageData.servers.then (servers) ->
    vm.servers = servers

    for server in vm.servers
      do (server) ->
        server.customGET('status').then (status) ->
          _.extend(server, { reachable, docker_available, execution_server_available } = status)

  pageData.repositories.then (repositories) ->
    vm.repositories = repositories

    for repository in vm.repositories
      repository.customGET('status').then (response) ->
        status = response.plain()
        _.extend(repository, status)

  vm
