angular.module 'WFMS.ProcessDesign'
.directive 'controlFlow', ($compile, processDesignerConfig) ->
  restrict: 'A'
  replace: true
  templateNamespace: 'svg'
  templateUrl: '/templates/process_designer/process_elements/control_flow'
  scope:
    controlFlow: '=controlFlow'
    processDesigner: '=processDesigner'
  link: (scope, elem, attrs) ->
    scope.controlFlow.domElement = elem
