angular.module 'User'
.controller 'UsersPageController', (tab, pageData, PageController) -> 
  vm = new PageController tab, pageData
  pageData.users.then (users) ->
    vm.users = users
    vm.setPageTitle('Users')

  vm
