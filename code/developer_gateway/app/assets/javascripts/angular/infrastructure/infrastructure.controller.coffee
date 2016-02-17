angular.module 'WFMS.Infrastructure'
.controller 'InfrastructureController', (servers) ->
  vm = @
  vm.servers = servers

  vm
