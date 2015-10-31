angular.module 'TabManagement'
.factory 'PageTypes', (uuid4) ->
  contentTemplateUrl = (type) -> "templates/#{type}/content"
  topBarTemplateUrl = (type) -> "templates/#{type}/top_bar"

  User:
    icon: 'icon-user'
    params: (id) -> type: 'User', id: id
    views:
      top_bar:
        templateUrl: topBarTemplateUrl 'user'
      content:
        templateUrl: contentTemplateUrl 'user'
        controller: 'UserPageController'
        controllerAs: 'userCtrl'

  Workflow:
    icon: 'icon-workflow'
    params: (id) -> type: 'Workflow', id: id
    views:
      top_bar:
        templateUrl: topBarTemplateUrl 'workflow'
      content:
        templateUrl: contentTemplateUrl 'workflow'
        controller: 'WorkflowPageController'
        controllerAs: 'wfCtrl'
