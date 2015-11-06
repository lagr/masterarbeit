angular.module 'Common'
.factory 'PageController', (tabManagement) ->
  class PageController
    constructor: (@tab, @pageData) ->

    stopEditing: -> @editing = false
    startEditing: -> @editing = true
