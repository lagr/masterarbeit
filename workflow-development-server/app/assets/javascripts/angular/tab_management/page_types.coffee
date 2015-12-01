angular.module 'WFMS.TabManagement'
.factory 'PageTypes', (uuid4, Restangular, Workflows) ->
  editTemplateUrl = (type) -> "templates/#{type}/edit"
  indexTemplateUrl = (type) -> "templates/#{type}/index"
  topBarTemplateUrl = (type) -> "templates/#{type}/top_bar"

  User:
    icon: 'icon-user'
    params: (id) -> 
      type: 'User'
      id: id
    resolves: (params) ->
      user: Restangular.one('users', params['id']).get()
    template: editTemplateUrl 'user'
    controller: 'UserPageController'

  Users:
    icon: 'icon-groups-friends'
    params: (id) -> 
      type: 'Users'
      id: null
    resolves: (params) ->
      users: Restangular.all('users').getList()
    template: indexTemplateUrl 'user'
    controller: 'UsersPageController'

  Workflow:
    icon: 'icon-algorhythm'
    params: (id) -> 
      type: 'Workflow'
      id: id
    resolves: (params) -> 
      workflow: Workflows.get(params['id'])
    template: editTemplateUrl('workflow')
    controller: 'WorkflowPageController'

  Workflows:
    icon: 'icon-algorhythm'
    params: -> 
      type: 'Workflows'
      id: null
    resolves: (params) -> 
      workflows: Workflows.index()
    template: indexTemplateUrl('workflow')
    controller: 'WorkflowsPageController'

  WorkflowBundle:
    icon: 'icon-stacks'
    params: (id) -> 
      type: 'WorkflowBundle'
      id: id
    resolves: (params) -> 
      workflow_bundle: WorkflowBundles.get(params['id'])
    template: editTemplateUrl('workflow_bundle')
    controller: 'WorkflowBundlePageController'

  WorkflowBundles:
    icon: 'icon-stacks'
    params: -> 
      type: 'WorkflowBundles'
      id: null
    resolves: (params) -> 
      workflows: WorkflowBundles.index()
    template: indexTemplateUrl('workflow_bundle')
    controller: 'WorkflowBundlesPageController'

  ProcessDesigner:
    icon: 'icon-websitebuilder'
    params: (id) -> 
      type: 'ProcessDesigner'
      id: id
    resolves: (params) ->
      workflow: Restangular.one('workflows', params['id']).get(for_designer: true)
    template: 'templates/process_designer/index'
    controller: 'ProcessDesignerPageController'

  Server:
    icon: 'icon-server'
    params: (id) -> 
      type: 'Server'
      id: id
    resolves: (params) ->
      server: Restangular.one('servers', params['id']).get()
      images: Restangular.one('servers', params['id']).customGET('index_images')
    template: 'templates/infrastructure_management/edit'
    controller: 'ServerPageController'

  InfrastructureManagement:
    icon: 'icon-servers'
    params: ->
      type: 'InfrastructureManagement'
      id: null
    resolves: ->
      repositories: Restangular.all('servers').getList(role: 'repository')
      servers: Restangular.all('servers').getList()
    template: 'templates/infrastructure_management/index'
    controller: 'InfrastructureManagementPageController'
