angular.module 'TabManagement'
.directive 'tabMenuEntry', (tabManagement) ->
  replace: true
  scope:
    tab: '=tabMenuEntry'
  templateUrl: 'templates/sidebar/tab_menu_entry.html'
  link: (scope, elem, attrs) ->
    scope.tabManagement = tabManagement
