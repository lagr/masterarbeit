angular.module 'TabManagement'
.factory 'Tab', (uuid4, $state, $stateParams, PageTypes) ->
  class Tab
    constructor: (futureTabState) ->
      @tabId = futureTabState.tabId
      @name = futureTabState.stateName
      @page = futureTabState.futurePage if futureTabState.futurePage?
      @url = "/{type}/{subjectId}"
      @views = {}
      @views["#{@tabId}_top_bar"] = ($stateParams) -> PageTypes[$stateParams.type].views.top_bar
      @views["#{@tabId}_content"] = ($stateParams) -> PageTypes[$stateParams.type].views.content

    title: -> @page?.title || 'Title'

    sticky: true
    params:
      type: ''
      template: 'templates/page_loading'


