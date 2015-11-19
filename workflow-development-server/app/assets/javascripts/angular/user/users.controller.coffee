angular.module 'User'
.controller 'UsersPageController', (tab, pageData, PageController, Users, tabManagement, $mdToast) -> 
  vm = new PageController tab, pageData
  pageData.users.then (users) ->
    vm.users = users
    vm.setPageTitle('Users')

    vm.createUser = ->
      createOperation = Users.create()
        .then (user) -> 
          tabManagement.openPage("User", user.id)
          $mdToast.simple().content('User has been created')

        .catch (response) ->
          $mdToast.simple().content('Error while creating User')

      createOperation.then (toast) -> $mdToast.show(toast.position('top right'))

    vm.deleteUser = (user, event) ->
      event.stopPropagation()
      deleteOperation = Users.delete(user)
        .then -> 
          _.remove(vm.users, user)
          $mdToast.simple().content('User has been deleted')

        .catch ->
          $mdToast.simple().content('Error while deleting User')

      deleteOperation.then (toast) -> $mdToast.show(toast.position('top right'))

  vm
