angular.module 'ProcessDesign'
.directive 'processDesigner', (tabManagement, processDesignerConfig) ->
  controller = ($element) ->
    vm = @
    vm.config = processDesignerConfig

    vm.svg = $element.find("svg")[0]
    vm.elementsContainer = $element.find("svg").find('.workflow-elements')[0]
    vm.referencePoint = vm.svg.createSVGPoint()

    activate = ->
      vm.selected = []
      vm.selectMultiple = false

      vm.canvasClicked = canvasClicked
      vm.elementMousedown = elementMousedown
      vm.canvasMouseup = canvasMouseup
      vm.canvasMousemove = canvasMousemove
      vm.isSelected = isSelected

      vm.workflowElements = -> vm.workflow_version.workflow_elements
      vm

    toRelativeCoordinates = (element, clientX, clientY) ->
      bbRect = element.getBoundingClientRect()
      [x, y] = [clientX - bbRect.left, clientY - bbRect.top]

    toElementCoordinates = (element, x, y) ->
      pt = vm.referencePoint
      [pt.x, pt.y] = [x, y]
      transformed = pt.matrixTransform(element.getScreenCTM().inverse())
      [transformed.x, transformed.y]

    isSelected = (element) ->_.contains(vm.selected, element)
    isCanvas = (target) -> _.contains(target.classList, 'grid')
    applyRaster = (number) -> Math.round(number / vm.config.canvas.raster, 0) * vm.config.canvas.raster

    elementMousedown = (element, event) ->
      vm.canvas.disablePan()
      if event.shiftKey
        toggleElementSelected(element)
      else
        selectElement(element)

      startDragging(element, event) 

    canvasMouseup = (event) ->
      vm.canvas.enablePan()
      stopDragging()

    canvasMousemove = (event) ->
      drag(event)

    canvasClicked = (event) ->
      return unless isCanvas(event.target)
      vm.selected = []
      toggleCircleMenu(event)

    stopDragging = ->
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

    activate()

  link = (scope, elem, attrs, ctrl) ->
    isBound = scope.$watch 'processDesigner.workflow_version', ->
      return unless scope.processDesigner.workflow_version
      svg = elem.find("svg")[0]

      scope.processDesigner.canvas = zoomableCanvas = svgPanZoom(svg, processDesignerConfig.canvas.panZoom)
      zoomableGrid = svgPanZoom(svg, { viewportSelector: 'rect.grid', fit: false })
      
      zoomableCanvas.setOnPan (point) -> zoomableGrid.pan(point)
      zoomableCanvas.setOnZoom (level) -> zoomableGrid.zoom(level)

      scope.processDesigner.zoom = zoomableCanvas.getZoom

      scope.$on '$destroy', -> zoomableCanvas.destroy()
      isBound()

  restrict: 'A'
  scope: true
  bindToController:
    workflow_version: '=processDesigner'
  controllerAs: 'processDesigner'
  link: link
  controller: controller
