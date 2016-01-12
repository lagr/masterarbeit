angular.module 'WFMS.ProcessDesign'
.factory 'Activities', (Restangular, $q) ->
  create: (type, processDefinitionId) ->
    activity =
      activity_type: type
      process_definition_id: processDefinitionId
      
    Restangular.restangularizeActivity(null, activity, 'activities').post()

  delete: (activity) ->
    Restangular.restangularizeActivity(null, activity, 'activities').remove()

  update: (activity) -> 
    activity = Restangular.restangularizeActivity(null, activity, 'activities')
    activity.put()
    $q.when()
