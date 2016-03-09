angular.module 'WFMS.Organization'
.controller 'RoleController', (role) ->
  vm = @
  vm.role = role

  vm.saveRole = -> vm.role.save()
  vm.deleteRole = -> vm.role.delete()
  vm
