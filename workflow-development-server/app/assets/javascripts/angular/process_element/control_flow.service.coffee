angular.module 'WFMS.ProcessDesign'
.factory 'ControlFlows', (Restangular) ->
  create: (controlFlow, processDefinition) ->
    controlFlow =
      predecessor_id: controlFlow.activity.id
      successor_id: controlFlow.targetActivity.id
    controlFlow = Restangular.restangularizeActivity(null, controlFlow, 'control_flows')
    controlFlow.post()
