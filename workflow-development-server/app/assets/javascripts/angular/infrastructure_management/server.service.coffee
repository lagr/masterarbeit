angular.module 'WFMS.Infrastructure'
.factory 'Server', (Restangular, uuid4) ->
  klass = 'servers'

  get: (id) -> Restangular.one(klass, id).get()
  status: (id) -> Restangular.one(klass, id).customGET('status')
  index: -> Restangular.all(klass).getList()
  create: -> Restangular.all(klass).post({})
  delete: (user) -> user.remove()
