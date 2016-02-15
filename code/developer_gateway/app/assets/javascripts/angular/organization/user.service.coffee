angular.module('WFMS.Organization').factory 'User', (RailsResource) ->
  class User extends RailsResource
    @configure
      url:"/users/{{id}}"
      name:"user"
