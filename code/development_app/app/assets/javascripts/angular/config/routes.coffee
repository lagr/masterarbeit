angular.module 'WFMS.WorkflowDevelopmentApplication'
.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
  states =
    # 'application':
    #   url: ''
    #   abstract: true
    #   template: '<ui-view/>'
    #   controller: 'ApplicationController'
    #   controllerAs: 'appCtrl'

    'dashboard':
      url: '/'
      title: 'Dashboard'
      templateUrl: 'dashboard.html'
      controller: 'DashboardController'
      controllerAs: 'dbCtrl'
      resolve:
        dashboardData: (Dashboard) -> Dashboard.getSummary()

    ## Workflows

    'workflow_management':
      url: '/workflow_management'
      abstract: true
      template: '<ui-view/>'
      controller: 'WorkflowManagementController'
      controllerAs: 'wfmCtrl'
      resolve:
        users: (User) -> User.index()
        roles: (Role) -> Role.index()
        workflows: (Workflow) -> Workflow.index()

    'workflow_management.workflows':
      url: '/workflows'
      templateUrl: 'templates/workflow_management/workflows.html'

    'workflow_management.workflow':
      url: '/workflow/:workflow_id'
      templateUrl: 'templates/workflow_management/workflow.html'
      controller: 'WorkflowController'
      controllerAs: 'wfCtrl'
      resolve:
        workflow: (workflows, $stateParams) -> _.find(workflows, id: $stateParams.workflow_id)
        users: (users) -> users
        roles: (roles) -> roles

    'workflow_management.workflow_model':
      url: '/workflow/workflow_id'
      templateUrl: 'templates/workflow_management/workflow_model.html'
      controller: 'WorkflowController'
      controllerAs: 'wfCtrl'
      resolve:
        workflow: (workflows, $stateParams) -> _.find(workflows, id: $stateParams.workflow_id)
        users: (users) -> users
        roles: (roles) -> roles

    ## Organization

    'organization':
      url: '/organization'
      abstract: true
      template: '<ui-view/>'
      controller: 'OrganizationController'
      controllerAs: 'orgCtrl'
      resolve:
        users: (User) -> User.index()
        roles: (Role) -> Role.index()

    'organization.roles':
      url: '/roles'
      templateUrl: 'templates/organization/roles.html'

    'organization.role':
      url: '/role/:role_id'
      templateUrl: 'templates/organization/role.html'
      controller: 'RoleController'
      controllerAs: 'roleCtrl'
      resolve:
        role: (roles, $stateParams) -> _.find(roles, id: $stateParams.role_id)

    'organization.users':
      url: '/users'
      templateUrl: 'templates/organization/users.html'

    'organization.user':
      url: '/user/:user_id'
      templateUrl: 'templates/organization/user.html'
      controller: 'UserController'
      controllerAs: 'userCtrl'
      resolve:
        user: (users, $stateParams) -> _.find(users, id: $stateParams.user_id)

    'infrastructure':
      url: '/infrastructure'
      template: '<ui-view/>'
      abstract: true


  $stateProvider.state(stateName, state) for stateName, state of states
  $urlRouterProvider.otherwise ($injector, $location) ->
    $injector.get('$state').go('dashboard')

  $locationProvider.html5Mode(false)


.run ($rootScope, $state) ->
  $rootScope.$state = $state
