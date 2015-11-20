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

  WorkflowVersion:
    icon: 'icon-algorhythm'
    params: (id) -> 
      type: 'WorkflowVersion'
      id: id
    resolves: (params) ->
      workflow_version: Restangular.one('workflow_versions', params['id']).get()
    template: editTemplateUrl('workflow_version')
    controller: 'WorkflowVersionPageController'

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
      workflow_version: Restangular.one('workflow_versions', params['id']).get(for_designer: true)
    template: 'templates/process_designer/index'
    controller: 'ProcessDesignerPageController'
