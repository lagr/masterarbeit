angular.module 'WFMS.WorkflowDevelopmentApplication'
.run (formlyConfig) ->

  types =
    input:
      name: 'input',
      template: '<input ng-model="model[options.key]" />'
  
  formlyConfig.setType(type) for typeName, type of types
