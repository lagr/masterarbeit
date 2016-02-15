angular.module 'WFMS.Organization'
.controller 'RoleController', (role) ->
  vm = @
  vm.role = role

  vm.saveRole = ->
    vm.role.update()
  vm
