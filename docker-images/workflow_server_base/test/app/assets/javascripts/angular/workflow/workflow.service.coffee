angular.module 'Workflow'
.factory 'Workflows', (Restangular) ->
  get: (id) -> Restangular.one('workflows', id).get()
  index: -> Restangular.all('workflows').getList() 
