angular.module('WFMS.Workflow').factory 'ProcessDefinition', (RailsResource, railsSerializer, uuid4) ->
  class ProcessDefinition extends RailsResource
    @configure
      url: "/process_definitions/{{id}}"
      name: "process_definition"
      serializer: railsSerializer( ->
        @only 'id'
        @resource 'activities', 'Activity'
        @resource 'controlFlows', 'ControlFlow'
      )
