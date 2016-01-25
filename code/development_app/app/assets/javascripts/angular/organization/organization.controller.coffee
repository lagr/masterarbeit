angular.module 'WFMS.Organization'
.controller 'OrganizationController', (users, roles) ->
  vm = @
  vm.users = users
  vm.roles = roles
  console.log "OrganizationController"
  vm
