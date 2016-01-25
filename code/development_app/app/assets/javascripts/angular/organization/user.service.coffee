angular.module 'WFMS.Organization'
.factory 'User', (Restangular, uuid4) ->
  klass = 'users'

  get: (id) -> Restangular.one(klass, id).get()
  index: -> Restangular.all(klass).getList()
  create: -> Restangular.all(klass).post({})
