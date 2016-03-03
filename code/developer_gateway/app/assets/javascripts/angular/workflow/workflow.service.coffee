angular.module('WFMS.Workflow').factory 'Workflow', (RailsResource, railsSerializer, uuid4) ->
  class Workflow extends RailsResource
    @configure
      url: "/workflows/{{id}}"
      name: "workflow"
      serializer: railsSerializer ->
        @only 'id', 'name'
        @resource 'processDefinition', 'ProcessDefinition'

    startInstance: (queryParams, authorId) ->
      @$patch @$url('/start')

