angular.module 'ProcessDesign'
.constant 'processDesignerConfig', 
  canvas:
    raster: 10
    panZoom:
      maxZoom: 10
      fit: false 
      minZoom: 0.5
      viewportSelector: 'g.workflow-elements'
      preventMouseEventsDefault: false
