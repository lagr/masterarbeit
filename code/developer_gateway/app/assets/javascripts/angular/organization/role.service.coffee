angular.module('WFMS.Organization').factory 'Role', (RailsResource, uuid4) ->
  class Role extends RailsResource
    @configure
      url:"/roles/{{id}}"
      name:"role"
    constructor: ->

