angular.module 'WFMS.Dashboard'
.factory 'Dashboard', (uuid4) ->
  getSummary: -> {}#Restangular.customGET('/dashboard/summary.json').get()

