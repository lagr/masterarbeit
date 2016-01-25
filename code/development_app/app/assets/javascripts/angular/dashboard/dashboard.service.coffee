angular.module 'WFMS.Dashboard'
.factory 'Dashboard', (Restangular, uuid4) ->
  getSummary: -> {}#Restangular.customGET('/dashboard/summary.json').get()

