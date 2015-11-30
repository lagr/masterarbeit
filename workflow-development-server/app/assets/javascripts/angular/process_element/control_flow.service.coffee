angular.module 'WFMS.ProcessDesign'
.factory 'ControlFlows', (Restangular) ->
  create: (controlFlow, processDefinition) ->
    controlFlow =
      predecessor_id: controlFlow.element.id
      successor_id: controlFlow.targetElement.id
    controlFlow = Restangular.restangularizeElement(null, controlFlow, 'control_flows')
    controlFlow.post()
