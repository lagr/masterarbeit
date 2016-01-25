angular.module 'WFMS.WorkflowDevelopmentApplication'
.config (RestangularProvider) ->
  RestangularProvider.setRequestSuffix('.json')
