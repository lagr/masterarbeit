angular.module 'WFMS.ProcessDesign'
.factory 'ControlFlows', (Restangular) ->
  create: (controlFlow, processDefinition) ->
    controlFlow =
      predecessor_id: controlFlow.element.element_data.id
      predecessor_type: controlFlow.element.element_type
      successor_id: controlFlow.targetElement.element_data.id
      successor_type: controlFlow.targetElement.element_type
      process_definition_id: processDefinition.id
    controlFlow = Restangular.restangularizeElement(null, controlFlow, 'control_flows')
    controlFlow.post()
