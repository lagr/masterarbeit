angular.module 'TabManagement'
.factory 'tabManagement', (uuid4, $state, $previousState, $stickyState, $window, FutureTabState, PageTypes, Tab) ->
  closedTabs = []
  states = -> $state.get()
  tabs = -> (state for state in states() when state instanceof Tab and state.name not in closedTabs)

  createTab = (tabId, futurePage) ->
    futureTabState = new FutureTabState(tabId, futurePage)
    window.futureStateProvider.futureState(futureTabState)
    futureTabState

  activateTab = (tab, stateParams) ->
    return unless tab
    $state.go(tab.name, tab.page)

  closeTab = (tab) ->
    openTabs = tabs()
    if openTabs.length < 2
      $state.go 'application.dashboard'
    else
      if $state.is(tab.name)
        currentIndex = openTabs.indexOf(tab)
        goIndex = if currentIndex is 0 then 1 else currentIndex - 1
        activateTab openTabs[goIndex]

    $stickyState.reset(tab.name)
    closedTabs.push tab.name

  openPage = (type, id) ->
    return unless type
    pageParams = PageTypes[type].params(id)
    target = $state.current
    
    if target.name is 'application.dashboard'
      openPageInNewTab(type, id)
    else
      $state.go target.name, pageParams

  openPageInNewTab = (type, id) ->
    return unless type
    pageParams = PageTypes[type].params(id)
    $state.go createTab(null, pageParams).stateName, pageParams

  $window.state = $state

  $window.tabManagement =
    tabs: tabs
    createTab: createTab
    activateTab: activateTab
    closeTab: closeTab
    openPage: openPage
    openPageInNewTab: openPageInNewTab