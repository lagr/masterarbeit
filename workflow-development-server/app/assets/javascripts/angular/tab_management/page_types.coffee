angular.module 'TabManagement'
.factory 'PageTypes', (uuid4, Restangular) ->
  editTemplateUrl = (type) -> "templates/#{type}/edit"
  indexTemplateUrl = (type) -> "templates/#{type}/index"
  topBarTemplateUrl = (type) -> "templates/#{type}/top_bar"

  User:
    icon: 'icon-user'
    params: (id) -> 
      type: 'User'
      id: id
    resolves: (params) ->
      user: Restangular.one('users', params['id']).get().$object
    template: editTemplateUrl 'user'
    controller: 'UserPageController'

  Workflow:
    icon: 'icon-workflow'
    params: (id) -> 
      type: 'Workflow'
      id: id
    resolves: (params) -> 
      workflow: Restangular.one('workflows', params['id']).get().$object
    template: editTemplateUrl('workflow')
    controller: 'WorkflowPageController'

  Workflows:
    icon: 'icon-workflow'
    params: -> 
      type: 'Workflows'
    resolves: (params) -> 
      workflows: Restangular.all('workflows').getList().$object
    template: indexTemplateUrl('workflow')
    controller: 'WorkflowsPageController'

  WorkflowVersion:
    icon: 'icon-workflow'
    params: (id) -> 
      type: 'WorkflowVersion'
      id: id
    resolves: (params) ->
      workflow_version: Restangular.one('workflow_versions', params['id']).get().$object
    template: editTemplateUrl('workflow_version')
    controller: 'WorkflowVersionPageController'

  ProcessDesigner:
    icon: 'icon-workflow-designer'
    params: (id) -> 
      type: 'ProcessDesigner'
      id: id
    resolves: (params) ->
      workflow_version: Restangular.one('workflow_versions', params['id']).get(for_designer: true).$object
    template: 'templates/process_designer/index'
    controller: 'ProcessDesignerPageController'
