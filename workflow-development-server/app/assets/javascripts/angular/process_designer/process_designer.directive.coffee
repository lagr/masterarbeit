angular.module 'WFMS.ProcessDesign'
.directive 'processDesigner', (tabManagement, processDesignerConfig, Activities, ActivityRepresentations, ControlFlows, $mdToast) ->
  class Activity
    constructor: (activity) ->
      _.extend @, activity

  class ControlFlow
    constructor: (controlFlow, @processDesigner) ->
      @successor = _.find @processDesigner.activities, (activity) ->
        activity.id == controlFlow.successor.id

      @predecessor = _.find @processDesigner.activities, (activity) -> 
        activity.id == controlFlow.predecessor.id

    xFrom: -> @predecessor.representation.x + 100
    yFrom: -> @predecessor.representation.y + 50
    xTo: -> @successor.representation.x
    yTo: -> @successor.representation.y + 50

  controller = ($scope, $element) ->
    vm = @
    vm.config = processDesignerConfig

    vm.svg = $element.find("svg")[0]
    vm.activitiesContainer = $element.find("svg").find('.activities')[0]
    vm.referencePoint = vm.svg.createSVGPoint()

    activate = ->
      vm.selected = []
      vm.dragging = false
      vm.connecting = false

      vm.canvasClicked = canvasClicked
      vm.activityMousedown = activityMousedown
      vm.activityMouseup = activityMouseup
      vm.canvasMouseup = canvasMouseup
      vm.canvasMousedown = canvasMousedown
      vm.canvasMousemove = canvasMousemove
      vm.canvasKeypress = canvasKeypress
      vm.isSelected = isSelected

      vm.detailsBarVisible = detailsBarVisible
      vm.newControlFlowVisible = newControlFlowVisible
      vm.selectedActivityHasType = selectedActivityHasType

      vm.createActivity = createActivity
      vm.deleteActivity = deleteActivity
      vm.saveActivity = saveActivity

      bindWorkflowVersion = $scope.$watch 'processDesigner.workflow', (newVal, oldVal) ->
        return unless newVal?
        vm.processDefinition = vm.workflow.process_definition
        vm.activities = (new Activity(activity) for activity in vm.processDefinition.activities)
        vm.controlFlows = (new ControlFlow(controlFlow, vm) for controlFlow in vm.processDefinition.control_flows)
        bindWorkflowVersion()

      vm

    toRelativeCoordinates = (activity, clientX, clientY) ->
      bbRect = activity.getBoundingClientRect()
      [x, y] = [clientX - bbRect.left, clientY - bbRect.top]

    toActivityCoordinates = (activity, x, y) ->
      pt = vm.referencePoint
      [pt.x, pt.y] = [x, y]
      transformed = pt.matrixTransform(activity.getScreenCTM().inverse())
      [transformed.x, transformed.y]

    isSelected = (activity) ->
      _.contains(vm.selected, activity)

    isCanvas = (target) ->
      _.contains(target.classList, 'grid')

    applyRaster = (number) -> 
      Math.round(number / vm.config.canvas.raster, 0) * vm.config.canvas.raster

    detailsBarVisible = ->
      vm.selected.length is 1 and not vm.dragging

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

      if event.shiftKey
        startNewControlFlow(activity, event)
      else
        if event.ctrlKey
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
      closeCircleMenu()         if vm.circleMenuVisible
      stopDragging()            if vm.dragging
      stopNewControlFlow(event) if vm.connecting

    canvasMousedown = (event) ->
      if event.shiftKey and isCanvas(event.target)
        vm.canvas.disablePan()
        [x, y] = toRelativeCoordinates(vm.svg, event.clientX, event.clientY)
        showCircleMenuAt(x, y)

    canvasMousemove = (event) ->
      updateCursorPos(event)
      drag(event)            if vm.dragging
      moveControlFlow(event) if vm.connecting

    canvasClicked = (event) ->
      return unless isCanvas(event.target)
      vm.selected = []

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
      ControlFlows.create(vm.newControlFlow, vm.processDefinition)
      .then (controlFlow) -> 
        vm.controlFlows.push new ControlFlow(controlFlow, vm)
      .catch -> console.log "ERROR"

    stopDragging = ->
      if vm.dragging and vm.dragTarget?
        for activity in vm.selected
          saveActivityRepresentation(activity)

      vm.dragging = false
      vm.dragTarget = undefined

    startDragging = (activity, event) ->
      activity.representation ||= {x: 0, y: 0}
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
          Activities.delete(activity).then ->
            _.remove(vm.activities, activity)

            for controlFlow in vm.controlFlows
              _.remove(vm.controlFlows, controlFlow) if controlFlow.predecessor is activity or controlFlow.successor is activity

    closeCircleMenu = ->
      vm.circleMenuVisible = false

    toggleCircleMenu = (event) ->
      switch event.shiftKey
        when false then closeCircleMenu()
        when true 
          [x, y] = toRelativeCoordinates(vm.svg, event.clientX, event.clientY)
          showCircleMenuAt(x, y)

    showCircleMenuAt = (x, y) ->
      vm.circleMenuPos = x: x, y: y
      vm.circleMenuVisible = true

    saveActivityRepresentation = (activity) ->
      ActivityRepresentations.update(activity.representation)

    createActivity = (type) ->
      Activities.create(type, vm.processDefinition.id)
      .then (activity) -> 
        vm.activities.push(new Activity(activity))
      .catch (response) ->

    deleteActivity = (activity) ->
      Activities.delete(activity)
      .then (activity) ->

    saveActivity = (activity) ->
      Activities.update(activity)
      .then (activity) ->

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
