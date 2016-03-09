angular.module 'WFMS.Organization'
.controller 'UserController', (user) ->
  vm = @
  vm.user = user

  vm.saveUser = -> vm.user.save()
  vm.deleteUser = -> vm.user.delete()
  vm
