angular.module 'WFMS.ProcessDefinition'
.directive 'processDesigner', (processDesignerConfig, ProcessDefinition, ControlFlow, Activity, $mdSidenav) ->
  controller = ($scope, $element, Role) ->
    vm = @
    vm.config = processDesignerConfig

    Role.query().then (roles) ->
      vm.roles = roles

    vm.svg = $element.find("svg")[0]
    vm.activitiesContainer = $element.find("svg").find('.activities')[0]
    vm.referencePoint = vm.svg.createSVGPoint()

    activate = ->
      vm.selected = []
      vm.dragging = false
      vm.connecting = false

      vm.activityMousedown = activityMousedown
      vm.activityMouseup = activityMouseup
      vm.canvasClicked = canvasClicked
      vm.canvasKeypress = canvasKeypress
      vm.canvasMousedown = canvasMousedown
      vm.canvasMousemove = canvasMousemove
      vm.canvasMouseup = canvasMouseup
      vm.isSelected = isSelected

      vm.detailsBarVisible = detailsBarVisible
      vm.newControlFlowVisible = newControlFlowVisible
      vm.selectedActivityHasType = selectedActivityHasType

      vm.createActivity = createActivity

      vm.processDefinition = vm.workflow.processDefinition
      vm.activities = vm.workflow.processDefinition.activities
      vm.controlFlows = vm.workflow.processDefinition.controlFlows

      resolveControlFlows()
      vm

    resolveControlFlows = ->
      for controlFlow in vm.controlFlows
        controlFlow.successor = _.find(vm.activities, id: controlFlow.successorId)
        controlFlow.predecessor = _.find(vm.activities, id: controlFlow.predecessorId)

    toRelativeCoordinates = (activity, clientX, clientY) ->
      bbRect = activity.getBoundingClientRect()
      [x, y] = [clientX - bbRect.left, clientY - bbRect.top]

    toActivityCoordinates = (activity, x, y) ->
      pt = vm.referencePoint
      [pt.x, pt.y] = [x, y]
      transformed = pt.matrixTransform(activity.getScreenCTM().inverse())
      [transformed.x, transformed.y]

    isSelected = (activity) -> _.contains(vm.selected, activity)
    isCanvas = (target) -> _.contains(target.classList, 'grid')

    applyRaster = (number) -> Math.round(number / vm.config.canvas.raster, 0) * vm.config.canvas.raster
    detailsBarVisible = -> vm.selected.length is 1 and not vm.dragging

    createActivity = (type) ->
        activity = new Activity(activityType: type, processDefinitionId: vm.processDefinition.id, workflowId: vm.workflow.id)
        activity.create().then -> vm.activities.push(activity)

    newControlFlowVisible = ->
      vm.connecting &&
      vm.newControlFlow.activity.representation.x? &&
      vm.newControlFlow.activity.representation.y? &&
      vm.newControlFlow.xTo? &&
      vm.newControlFlow.yTo?

    selectedActivityHasType = (type) ->
      return unless type && vm.selected.length is 1
      _.first(vm.selected)?.activity_type is type

    activityMousedown = (activity, event) ->
      vm.canvas.disablePan()

      if event.ctrlKey
        selectActivity(activity)
        showActivityDetails()
        return

      if event.shiftKey
        startNewControlFlow(activity, event)
      else
        if event.altKey
          toggleActivitySelected(activity)
        else
          selectActivity(activity)

        startDragging(activity, event)

    activityMouseup = (activity, event) ->
      if vm.connecting
        vm.newControlFlow.targetActivity = activity
        createControlFlow()
        stopNewControlFlow()

    canvasMouseup = (event) ->
      vm.canvas.enablePan()
      closeMenu()         if vm.menuVisible
      stopDragging()            if vm.dragging
      stopNewControlFlow(event) if vm.connecting

    showActivityDetails = -> $mdSidenav('details_bar').open()
    hideActivityDetails = -> $mdSidenav('details_bar').close()

    canvasMousedown = (event) ->
      if event.shiftKey and isCanvas(event.target)
        vm.canvas.disablePan()
        [x, y] = toRelativeCoordinates(vm.svg, event.clientX, event.clientY)
        showMenuAt(x, y)

    canvasMousemove = (event) ->
      updateCursorPos(event)
      drag(event)            if vm.dragging
      moveControlFlow(event) if vm.connecting

    canvasClicked = (event) ->
      return unless isCanvas(event.target)
      vm.selected = []
      $mdSidenav('details_bar').close()

    canvasKeypress = (event) ->
      switch event.keyCode
        when 127
          deleteSelected()

    updateCursorPos = (event) ->
      [x, y] = toActivityCoordinates(vm.svg, event.clientX, event.clientY)
      vm.cursor = x: x, y: y

    moveControlFlow = (event) ->
      [x, y] = toActivityCoordinates(vm.newControlFlow.startNode, event.clientX, event.clientY)
      vm.newControlFlow.xTo = x + vm.newControlFlow.activity.representation.x
      vm.newControlFlow.yTo = y + vm.newControlFlow.activity.representation.y

    startNewControlFlow = (activity, event) ->
      vm.connecting = true
      vm.newControlFlow = activity: activity, startNode: event.target

    stopNewControlFlow = ->
      vm.connecting = false
      vm.newControlFlow = {}

    createControlFlow = ->
      temp = vm.newControlFlow
      controlFlow = new ControlFlow {
        successor: temp.targetActivity
        predecessor: temp.activity
        successorId: temp.targetActivity.id
        predecessorId: temp.activity.id
        processDefinitionId: vm.processDefinition.id
      }
      controlFlow.create().then -> vm.controlFlows.push(controlFlow)

    stopDragging = ->
      if vm.dragging and vm.dragTarget?
        activity.save() for activity in vm.selected

      vm.dragging = false
      vm.dragTarget = undefined

    startDragging = (activity, event) ->
      activity.representation ||= x: 0, y: 0
      vm.dragging = true
      vm.dragTarget = event.target
      [vm.dragStartX, vm.dragStartY] = toActivityCoordinates(vm.dragTarget, event.clientX, event.clientY)

    drag = (event) ->
      return unless vm.dragging && vm.dragTarget

      [dragPosX, dragPosY] = toActivityCoordinates(vm.dragTarget, event.clientX, event.clientY)
      for activity in vm.selected
        activity.representation.x += dragPosX - vm.dragStartX
        activity.representation.y += dragPosY - vm.dragStartY

        activity.representation.x = applyRaster(activity.representation.x)
        activity.representation.y = applyRaster(activity.representation.y)

    selectActivity = (activity) ->
      vm.selected = [activity] unless isSelected(activity)

    toggleActivitySelected = (activity) ->
      if isSelected(activity)
        _.remove(vm.selected, activity)
      else
        vm.selected.push(activity)

    deleteSelected = ->
      if vm.selected.length
        for activity in vm.selected
          activity.delete().then (activity) -> _.remove(vm.activities, activity)

          for controlFlow in vm.controlFlows
            _.remove(vm.controlFlows, controlFlow) if controlFlow.predecessor is activity or controlFlow.successor is activity

    closeMenu = ->
      vm.menuVisible = false

    toggleMenu = (event) ->
      switch event.shiftKey
        when false then closeMenu()
        when true
          [x, y] = toRelativeCoordinates(vm.svg, event.clientX, event.clientY)
          showMenuAt(x, y)

    showMenuAt = (x, y) ->
      vm.menuPos = x: x, y: y
      vm.menuVisible = true

    activate()

  link = (scope, elem, attrs, ctrl) ->
    isBound = scope.$watch 'processDesigner.workflow', ->
      return unless scope.processDesigner.workflow
      svg = elem.find('svg')[0]
      grid = elem.find('#grid')[0]

      scope.processDesigner.canvas = zoomableCanvas = svgPanZoom(svg, processDesignerConfig.canvas.panZoom)
      viewport = elem.find('svg .svg-pan-zoom_viewport')[0]
      grid.setAttribute('patternTransform', viewport.getAttribute('transform'))

      zoomableCanvas.setOnPan (point) ->
        grid.setAttribute('patternTransform', viewport.getAttribute('transform'))

      scope.processDesigner.zoom = zoomableCanvas.getZoom

      scope.$on '$destroy', -> zoomableCanvas.destroy()
      isBound()

  restrict: 'A'
  scope: true
  bindToController:
    workflow: '=processDesigner'
  controllerAs: 'processDesigner'
  link: link
  controller: controller
