angular.module('WFMS.Infrastructure').factory 'Server', (RailsResource) ->
  class Server extends RailsResource
    @configure
      url:"/servers/{{id}}"
      name:"server"
