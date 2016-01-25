angular.module 'WFMS.Organization'
.factory 'Role', (Restangular, uuid4) ->
  klass = 'roles'

  get: (id) -> Restangular.one(klass, id).get()
  index: -> Restangular.all(klass).getList()
  create: -> Restangular.all(klass).post({})
