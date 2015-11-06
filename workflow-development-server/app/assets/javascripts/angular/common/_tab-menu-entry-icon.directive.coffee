angular.module 'Common'
.directive 'tabMenuEntryIcon', (PageTypes) ->
  restrict: 'C'
  scope:
    type: '='
  link: (scope, elem, attrs) ->
    scope.$watch 'type', (newVal, oldVal) ->
      return unless scope.type?
      newTypeClass = PageTypes[newVal].icon
      oldTypeClass = PageTypes[oldVal].icon
      elem.removeClass(oldTypeClass || '')
      elem.addClass(newTypeClass || '')
