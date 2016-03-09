angular.module('WFMS.Workflow').factory 'ControlFlow', (RailsResource, railsSerializer, uuid4) ->
  class ControlFlow extends RailsResource
    @configure
      url: "/control_flows/{{id}}"
      name: "control_flow"
      serializer: railsSerializer( -> @only 'id', 'successorId', 'predecessorId', 'processDefinitionId' )

    xFrom: -> @predecessor?.representation?.x + 100 || 0
    yFrom: -> @predecessor?.representation?.y + 50 || 0
    xTo: -> @successor?.representation?.x || 0
    yTo: -> @successor?.representation?.y + 50 || 0
