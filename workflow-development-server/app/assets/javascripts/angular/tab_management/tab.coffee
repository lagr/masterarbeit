angular.module 'TabManagement'
.factory 'Tab', (uuid4, $q, $state, $injector, PageTypes) ->
  class Tab
    constructor: (futureTabState) ->
      @tabId = futureTabState.tabId
      @name = futureTabState.stateName
      @page = futureTabState.futurePage if futureTabState.futurePage?
      @url = "/{type}/{id}"

      @views =
        "tab":
          templateUrl: ($stateParams) => PageTypes[$stateParams.type]?.template
          controllerProvider: ($stateParams, PageTypes) -> PageTypes[$stateParams.type]?.controller
          controllerAs: 'pageCtrl'

      @resolve = 
        tab: -> @
        page: -> @page

      @onEnter = ($stateParams) ->
        @page = {} = $stateParams

    title: -> @page?.title || 'Title'
    type: -> @page?.type || ''

    sticky: true
    params:
      type: ''
      template: 'templates/page_loading'


