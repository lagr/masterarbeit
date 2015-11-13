angular.module 'User'
.controller 'UsersPageController', (tab, pageData, PageController) -> 
  vm = new PageController tab, pageData
  vm.users = pageData.users
  vm
