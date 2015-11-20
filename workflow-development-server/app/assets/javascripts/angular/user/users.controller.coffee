angular.module 'WFMS.User'
.controller 'UsersPageController', (tab, pageData, PageController, Users, tabManagement, $mdToast) -> 
  vm = new PageController tab, pageData
  pageData.users.then (users) ->
    vm.users = users
    vm.setPageTitle('Users')

    vm.createUser = ->
      Users.create()
        .then (user) -> 
          tabManagement.openPage("User", user.id)
          vm.showToast('User has been created')

        .catch (response) ->
          vm.showToast('Error while creating User')

    vm.deleteUser = (user, event) ->
      event.stopPropagation()
      Users.delete(user)
        .then -> 
          _.remove(vm.users, user)
          vm.showToast('User has been deleted')

        .catch ->
          vm.showToast('Error while deleting User')

  vm
