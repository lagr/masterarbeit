angular.module 'TabManagement'
.factory 'Tab', (uuid4, $q, $state, $injector, PageTypes) ->
  class Tab
    constructor: (futureTabState) ->
      @tabId = futureTabState.tabId
      @name = "application.#{@tabId}"
      @page = futureTabState.futurePage if futureTabState.futurePage?
      @url = "/tab/#{@tabId}/{type}/{id}"
      @views = {}
      @views[@tabId] =
        templateUrl: ($stateParams) => PageTypes[$stateParams.type]?.template
        controllerProvider: ($stateParams, PageTypes) -> PageTypes[$stateParams.type]?.controller
        controllerAs: 'pageCtrl'

      @onEnter = ($stateParams, pageData) ->
        @page = $stateParams

      @resolve =
        tab: => @ 
        pageData: ($stateParams, PageTypes) -> 
          deferred = $q.defer()
          resolves = PageTypes[$stateParams.type]?.resolves($stateParams)
          promises = (promise for key, promise of resolves)
          $q.all(promises).then => deferred.resolve(resolves)
          deferred.promise

    title: -> @page?.title || 'Title'
    type: -> @page?.type || ''

    sticky: true
    params:
      type: ''
      template: 'templates/page_loading'
