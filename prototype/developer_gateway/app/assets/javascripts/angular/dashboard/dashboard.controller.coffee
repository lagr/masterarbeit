angular.module 'WFMS.Dashboard'
.controller 'DashboardController', (dashboardData) ->
  vm = @
  vm.dashboardData = dashboardData
  console.log "DashboardController"
  vm
