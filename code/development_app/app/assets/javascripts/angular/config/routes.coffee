angular.module 'WFMS.WorkflowDevelopmentApplication'
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  states =
    'application':
      url: ''
      abstract: true
      templateUrl: 'application.html'

    'application.dashboard':
      url: '/'
      title: 'Dashboard'

  $stateProvider.state(stateName, state) for stateName, state of states
  $urlRouterProvider.otherwise('/')
