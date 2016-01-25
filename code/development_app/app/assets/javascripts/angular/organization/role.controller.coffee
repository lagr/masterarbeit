angular.module 'WFMS.Organization'
.controller 'RoleController', (role) ->
  vm = @
  vm.role = role
  console.log "RoleController"
  vm
