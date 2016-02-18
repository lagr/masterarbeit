angular.module('WFMS.Workflow').factory 'Activity', (RailsResource, railsSerializer, uuid4) ->
  class Activity extends RailsResource
    @configure
      url: "/activities/{{id}}"
      name: "activity"
      serializer: railsSerializer( ->
        @only 'id', 'activity_type', 'input_schema', 'output_schema',
              'activity_configuration', 'representation',
              'process_definition_id', 'subworkflow_id'
      )
