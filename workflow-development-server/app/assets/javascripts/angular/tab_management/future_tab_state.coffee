angular.module 'WFMS.TabManagement'
.factory 'FutureTabState', (uuid4) ->
  class FutureTabState
    type: 'tabState'  # determines futureStateProvider
    constructor: (@tabId, @futurePage) ->
      @tabId ||= uuid4.generate()
      @stateName = "application.#{@tabId}"
