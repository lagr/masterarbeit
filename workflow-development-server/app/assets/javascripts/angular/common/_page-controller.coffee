angular.module 'WFMS.Common'
.factory 'PageController', (tabManagement, $mdToast) ->
  class PageController
    constructor: (@tab, @pageData) ->
      @page = @tab.page
      @stopEditing()
      @

    setPageTitle: (title) -> @page.title = title if title?.length
    stopEditing: -> @editing = false
    startEditing: -> @editing = true
    showToast: (content) ->
      $mdToast.show(
        $mdToast.simple().content(content).position('top right')
      )

