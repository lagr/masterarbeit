angular.module 'WFMS.ProcessDefinition'
.directive 'controlFlow', ($compile, processDesignerConfig) ->
  restrict: 'A'
  replace: true
  templateNamespace: 'svg'
  templateUrl: '/templates/process_designer/elements/control_flow'
  scope:
    controlFlow: '=controlFlow'
  link: (scope, elem, attrs) ->
    scope.controlFlow.domElement = elem
