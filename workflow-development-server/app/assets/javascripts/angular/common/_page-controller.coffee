angular.module 'Common'
.factory 'PageController', (tabManagement) ->
  class PageController
    constructor: (@tab, @page) ->

    stopEditing: -> @editing = false
    startEditing: -> @editing = true
