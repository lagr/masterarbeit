angular.module 'WFMS.ProcessDesign'
.factory 'ProcessElements', (Restangular, $q) ->
  create: (type, processDefinitionId) ->
    processElement =
      element_type: type
      process_definition_id: processDefinitionId
      
    Restangular.restangularizeElement(null, processElement, 'process_elements').post()

  delete: (processElement) ->
    Restangular.restangularizeElement(null, processElement, 'process_elements').remove()

  update: (processElement) -> 
    processElement = Restangular.restangularizeElement(null, processElement, 'process_elements')
    processElement.put()
    $q.when()
