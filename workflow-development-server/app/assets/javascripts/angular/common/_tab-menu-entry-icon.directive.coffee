angular.module 'WFMS.Common'
.directive 'tabMenuEntryIcon', (PageTypes) ->
  restrict: 'C'
  scope:
    type: '='
  link: (scope, elem, attrs) ->
    scope.$watch 'type', (newType, oldType) ->
      return unless newType && newType?
      newTypeClass = PageTypes[newType].icon
      oldTypeClass = PageTypes[oldType].icon if oldType && oldType?
      elem.removeClass(oldTypeClass || '')
      elem.addClass(newTypeClass || '')
