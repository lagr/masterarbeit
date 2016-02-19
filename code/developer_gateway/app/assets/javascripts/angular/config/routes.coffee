angular.module 'WFMS.WorkflowDevelopmentApplication'
.run ($rootScope, $state) ->
  $rootScope.$state = $state

.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  states =
    'app':
      url: ''
      abstract: true
      templateUrl: 'application.html'
      controller: 'ApplicationController'
      controllerAs: 'appCtrl'

    'app.dashboard':
      url: '/'
      title: 'Dashboard'
      templateUrl: 'dashboard.html'
      controller: 'DashboardController'
      controllerAs: 'dbCtrl'
      resolve:
        dashboardData: (Dashboard) -> Dashboard.getSummary()

    'app.organization':
      url: '/organization'
      abstract: true
      template: '<ui-view flex layout="column"></ui-view>'
      controller: 'OrganizationController'
      controllerAs: 'orgCtrl'
      resolve:
        users: (User) -> User.query()
        roles: (Role) -> Role.query()

    'app.organization.roles':
      url: '/roles'
      templateUrl: 'templates/organization/roles.html'

    'app.organization.role':
      url: '/role/:role_id'
      templateUrl: 'templates/organization/role.html'
      controller: 'RoleController'
      controllerAs: 'roleCtrl'
      resolve:
        role: (roles, Role, $stateParams) ->
          _.find(roles, id: $stateParams.role_id) || new Role

    'app.organization.users':
      url: '/users'
      templateUrl: 'templates/organization/users.html'

    'app.organization.user':
      url: '/user/:user_id'
      templateUrl: 'templates/organization/user.html'
      controller: 'UserController'
      controllerAs: 'userCtrl'
      resolve:
        user: (users, User, $stateParams) ->
          _.find(users, id: $stateParams.user_id) || new User

    'app.infrastructure':
      url: '/infrastructure'
      abstract: true
      template: '<ui-view flex layout="column"></ui-view>'
      controller: 'InfrastructureController'
      controllerAs: 'infCtrl'
      resolve:
        servers: (Server) -> Server.query()

    'app.infrastructure.servers':
      url: '/servers'
      templateUrl: 'templates/infrastructure/servers.html'

    'app.infrastructure.server':
      url: '/server/:name'
      templateUrl: 'templates/infrastructure/server.html'
      controller: 'ServerController'
      controllerAs: 'serverCtrl'
      resolve:
        server: (Server, $stateParams) -> Server.get($stateParams.name)

    'app.workflow_management':
      url: '/workflow_management'
      abstract: true
      template: '<ui-view flex layout="column"></ui-view>'
      controller: 'WorkflowManagementController'
      controllerAs: 'wfmgmtCtrl'
      resolve:
        workflows: (Workflow) -> Workflow.query()

    'app.workflow_management.workflows':
      url: '/workflows'
      templateUrl: 'templates/workflow_management/workflows.html'

    'app.workflow_management.workflow':
      url: '/workflow/:workflow_id'
      templateUrl: 'templates/workflow_management/workflow.html'
      controller: 'WorkflowController'
      controllerAs: 'wfCtrl'
      resolve:
        workflow: (Workflow, $stateParams) -> Workflow.get($stateParams.workflow_id)

  $stateProvider.state(stateName, state) for stateName, state of states

  $urlRouterProvider.otherwise ($injector, $location) ->
    $injector.get('$state').go('app.dashboard')

  $locationProvider.html5Mode(false)
