angular.module 'WFMS.ProcessDesign'
.constant 'processDesignerConfig', 
  canvas:
    raster: 10
    panZoom:
      maxZoom: 10
      fit: false 
      minZoom: 0.5
      viewportSelector: 'g.process-elements'
      preventMouseEventsDefault: false

  processElements:
    StartElement:
      templateName: 'start_element'
    EndElement:
      templateName: 'end_element'
    ManualActivity:
      templateName: 'manual_activity'
