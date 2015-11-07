angular.module 'TabManagement'
.factory 'PageTypes', (uuid4, Restangular) ->
  contentTemplateUrl = (type) -> "templates/#{type}/edit"
  topBarTemplateUrl = (type) -> "templates/#{type}/top_bar"

  User:
    icon: 'icon-user'
    params: (id) -> 
      type: 'User'
      id: id
    resolves: (params) ->
      user: Restangular.one('users', params['id']).get().$object
    template: contentTemplateUrl 'user'
    controller: 'UserPageController'

  Workflow:
    icon: 'icon-workflow'
    params: (id) -> 
      type: 'Workflow'
      id: id
    resolves: (params) ->
      workflow: Restangular.one('workflows', params['id']).get().$object
    template: contentTemplateUrl('workflow')
    controller: 'WorkflowPageController'

  WorkflowVersion:
    icon: 'icon-workflow'
    params: (id) -> 
      type: 'WorkflowVersion'
      id: id
    resolves: (params) ->
      workflow_version: Restangular.one('workflow_versions', params['id']).get().$object
    template: contentTemplateUrl('workflow_version')
    controller: 'WorkflowVersionPageController'
