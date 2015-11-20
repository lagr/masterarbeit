angular.module 'WFMS.User'
.controller 'UserPageController', (tab, pageData, PageController) -> 
  vm = new PageController tab, pageData
  pageData.user.then (user) ->
    vm.user = user
    vm.setPageTitle(vm.user.last_name)

  vm
