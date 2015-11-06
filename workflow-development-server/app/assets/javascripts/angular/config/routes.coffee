angular.module 'WorkflowDevelopmentApplication'
.config ($stateProvider, $urlRouterProvider, $locationProvider, $futureStateProvider) ->
  states =
    'application':
      url: ''
      abstract: true
      templateUrl: 'application.html'
      controller: 'ApplicationController'
      controllerAs: 'appCtrl'

    'application.dashboard':
      url: '/dashboard'
      title: 'Dashboard'
      sticky: true
      views:
        asd:
          templateUrl: 'dashboard.html'
          controller: 'DashboardController'
          controllerAs: 'dbCtrl'
  
  $stateProvider.state(stateName, state) for stateName, state of states
  $urlRouterProvider.otherwise('/dashboard')

  window.futureStateProvider = $futureStateProvider
  $futureStateProvider.stateFactory 'tabState', ($q, futureState, Tab) -> $q.when new Tab(futureState)

  $locationProvider.html5Mode(false)

.run ($rootScope, $state, $previousState, $deepStateRedirect) ->
  window.dsr = $deepStateRedirect
  $rootScope.$state = $state
  $rootScope.$previousState = $previousState
