angular.module 'TabManagement'
.factory 'PageTypes', (uuid4) ->
  contentTemplateUrl = (type) -> "templates/#{type}/edit"
  topBarTemplateUrl = (type) -> "templates/#{type}/top_bar"

  User:
    icon: 'icon-user'
    params: (id) -> 
      type: 'User'
      id: id
    template: contentTemplateUrl 'user'
    controller: 'UserPageController'

  Workflow:
    icon: 'icon-workflow'
    params: (id) -> 
      type: 'Workflow'
      id: id
    template: contentTemplateUrl('workflow')
    controller: 'WorkflowPageController'
