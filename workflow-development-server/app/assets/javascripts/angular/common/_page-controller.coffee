angular.module 'Common'
.factory 'PageController', (tabManagement) ->
  class PageController
    constructor: (@tab, @pageData) ->
      @page = @tab.page

    setPageTitle: (title) -> @page.title = title if title?.length
    stopEditing: -> @editing = false
    startEditing: -> @editing = true
