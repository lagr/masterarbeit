angular.module 'WFMS.ProcessDesign'
.directive 'processDesigner', (tabManagement, processDesignerConfig, ProcessElementRepresentations, ControlFlows) ->
  class ProcessElement
    constructor: (element) ->
      _.extend @, element

    center: ->

  class ControlFlow
    constructor: (controlFlow, @processDesigner) ->
      @successor = _.find @processDesigner.processElements, (element) -> 
        element.element_data.id == controlFlow.successor.id

      @predecessor = _.find @processDesigner.processElements, (element) -> 
        element.element_data.id == controlFlow.predecessor.id

    xFrom: -> @predecessor.representation.x
    yFrom: -> @predecessor.representation.y
    xTo: -> @successor.representation.x
    yTo: -> @successor.representation.y

  controller = ($scope, $element) ->
    vm = @
    vm.config = processDesignerConfig

    vm.svg = $element.find("svg")[0]
    vm.elementsContainer = $element.find("svg").find('.process-elements')[0]
    vm.referencePoint = vm.svg.createSVGPoint()

    activate = ->
      vm.selected = []
      vm.dragging = false
      vm.connecting = false

      vm.canvasClicked = canvasClicked
      vm.elementMousedown = elementMousedown
      vm.elementMouseup = elementMouseup
      vm.canvasMouseup = canvasMouseup
      vm.canvasMousemove = canvasMousemove
      vm.isSelected = isSelected

      vm.detailsBarVisible = detailsBarVisible
      vm.newControlFlowVisible = newControlFlowVisible
      vm.selectedElementHasType = selectedElementHasType

      bindWorkflowVersion = $scope.$watch 'processDesigner.workflowVersion', (newVal, oldVal) ->
        return unless newVal?
        vm.processDefinition = vm.workflowVersion.process_definition
        vm.processElements = (new ProcessElement(element) for element in vm.processDefinition.process_elements)
        vm.controlFlows = (new ControlFlow(controlFlow, vm) for controlFlow in vm.processDefinition.control_flows)
        bindWorkflowVersion()

      vm

    toRelativeCoordinates = (element, clientX, clientY) ->
      bbRect = element.getBoundingClientRect()
      [x, y] = [clientX - bbRect.left, clientY - bbRect.top]

    toElementCoordinates = (element, x, y) ->
      pt = vm.referencePoint
      [pt.x, pt.y] = [x, y]
      transformed = pt.matrixTransform(element.getScreenCTM().inverse())
      [transformed.x, transformed.y]

    isSelected = (element) ->
      _.contains(vm.selected, element)

    isCanvas = (target) ->
      _.contains(target.classList, 'grid')

    applyRaster = (number) -> 
      Math.round(number / vm.config.canvas.raster, 0) * vm.config.canvas.raster

    detailsBarVisible = ->
      vm.selected.length is 1 and not vm.dragging

    newControlFlowVisible = ->
      vm.connecting &&
      vm.newControlFlow.element.representation.x? &&
      vm.newControlFlow.element.representation.y? &&
      vm.newControlFlow.xTo? &&
      vm.newControlFlow.yTo?

    selectedElementHasType = (type) ->
      return unless type && vm.selected.length is 1
      _.first(vm.selected)?.element_type is type

    elementMousedown = (element, event) ->
      vm.canvas.disablePan()

      if event.shiftKey
        startNewControlFlow(element, event)
      else
        if event.ctrlKey
          toggleElementSelected(element)
        else
          selectElement(element)

        startDragging(element, event) 

    elementMouseup = (element, event) ->
      if vm.connecting
        vm.newControlFlow.targetElement = element
        createControlFlow()
        stopNewControlFlow()

    canvasMouseup = (event) ->
      vm.canvas.enablePan()
      stopDragging() if vm.dragging
      stopNewControlFlow(event) if vm.connecting

    canvasMousemove = (event) ->
      updateCursorPos(event)
      drag(event) if vm.dragging
      moveControlFlow(event) if vm.connecting

    canvasClicked = (event) ->
      return unless isCanvas(event.target)
      vm.selected = []
      toggleCircleMenu(event)

    updateCursorPos = (event) ->
      [x, y] = toElementCoordinates(vm.svg, event.clientX, event.clientY)
      vm.cursor = x: x, y: y

    moveControlFlow = (event) ->
      [x, y] = toElementCoordinates(vm.newControlFlow.startNode, event.clientX, event.clientY)
      vm.newControlFlow.xTo = x + vm.newControlFlow.element.representation.x
      vm.newControlFlow.yTo = y + vm.newControlFlow.element.representation.y

    startNewControlFlow = (element, event) ->
      vm.connecting = true
      vm.newControlFlow = element: element, startNode: event.target

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
        for element in vm.selected
          saveElementRepresentation(element)

      vm.dragging = false
      vm.dragTarget = undefined

    startDragging = (element, event) ->
      element.representation ||= {x: 0, y: 0}
      vm.dragging = true
      vm.dragTarget = event.target
      [vm.dragStartX, vm.dragStartY] = toElementCoordinates(vm.dragTarget, event.clientX, event.clientY)

    drag = (event) ->
      return unless vm.dragging && vm.dragTarget

      [dragPosX, dragPosY] = toElementCoordinates(vm.dragTarget, event.clientX, event.clientY)
      for element in vm.selected
        element.representation.x += dragPosX - vm.dragStartX
        element.representation.y += dragPosY - vm.dragStartY

        element.representation.x = applyRaster(element.representation.x)
        element.representation.y = applyRaster(element.representation.y)

    selectElement = (element) ->
      vm.selected = [element] unless isSelected(element)

    toggleElementSelected = (element) ->
      if isSelected(element)
        _.remove(vm.selected, element)
      else
        vm.selected.push(element)

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

    saveElementRepresentation = (element) ->
      ProcessElementRepresentations.update(element.representation)

    activate()

  link = (scope, elem, attrs, ctrl) ->
    isBound = scope.$watch 'processDesigner.workflowVersion', ->
      return unless scope.processDesigner.workflowVersion
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
    workflowVersion: '=processDesigner'
  controllerAs: 'processDesigner'
  link: link
  controller: controller
