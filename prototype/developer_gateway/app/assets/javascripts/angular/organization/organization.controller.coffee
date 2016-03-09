angular.module 'WFMS.Organization'
.controller 'OrganizationController', (users, roles, User, Role, $state) ->
  vm = @
  vm.users = users
  vm.roles = roles

  vm
