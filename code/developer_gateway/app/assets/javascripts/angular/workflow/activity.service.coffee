angular.module('WFMS.Workflow').factory 'Activity', (RailsResource, railsSerializer, uuid4) ->
  class Activity extends RailsResource
    @configure
      url: "/activities/{{id}}"
      name: "activity"
      # serializer: railsSerializer( ->
      #   # @only 'id', 'activityType', 'inputSchema', 'outputSchema',
      #   #       'activityConfiguration', 'representation',
      #   #       'processDefinitionId', 'subworkflowId'
      #   # @nestedAttribute 'representation'
      # )
    constructor: (data) ->
      super(data)
      _.defaults @representation, { x: 0, y: 0 }
      @inputSchema ||= {}
      @outputSchema ||= {}
      @activityConfiguration ||= {}
