angular.module 'WFMS.ProcessDesign'
.factory 'ActivityRepresentations', (Restangular) ->
  update: (activityRepresentation) -> 
    prElRep = Restangular.restangularizeActivity(null, activityRepresentation, 'activity_representations')
    prElRep.put()
