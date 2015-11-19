angular.module 'Workflow'
.factory 'Workflows', (Restangular, uuid4) ->
  klass = 'workflows'

  get: (id) -> Restangular.one(klass, id).get()
  index: -> Restangular.all(klass).getList()
  create: -> Restangular.all('workflows').post({})
  delete: (workflow) -> workflow.remove()
