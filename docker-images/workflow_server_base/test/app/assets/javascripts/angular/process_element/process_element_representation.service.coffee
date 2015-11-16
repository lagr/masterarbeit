angular.module 'ProcessDesign'
.factory 'ProcessElementRepresentations', (Restangular) ->
  update: (processElementRepresentation) -> 
    prElRep = Restangular.restangularizeElement(null, processElementRepresentation, 'process_element_representations')
    prElRep.put()
