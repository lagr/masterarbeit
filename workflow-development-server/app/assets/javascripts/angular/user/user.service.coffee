angular.module 'User'
.factory 'Users', (Restangular, uuid4) ->
  klass = 'users'

  get: (id) -> Restangular.one(klass, id).get()
  index: -> Restangular.all(klass).getList()
  create: -> Restangular.all(klass).post({})
  delete: (user) -> user.remove()
