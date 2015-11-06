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
      user: Restangular.one('users', params['id']).get()
    template: contentTemplateUrl 'user'
    controller: 'UserPageController'

  Workflow:
    icon: 'icon-workflow'
    params: (id) -> 
      type: 'Workflow'
      id: id
    resolves: (params) ->
      workflow: Restangular.one('workflows', params['id']).get()
    template: contentTemplateUrl('workflow')
    controller: 'WorkflowPageController'
