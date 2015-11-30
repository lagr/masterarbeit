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
    OrSplitElement:
      templateName: 'or_split_element'
    OrJoinElement:
      templateName: 'or_join_element'
    AndSplitElement:
      templateName: 'and_split_element'
    AndJoinElement:
      templateName: 'and_join_element'
    AutomaticActivity:
      templateName: 'automatic_activity'
    ContainerizedActivity:
      templateName: 'containerized_activity'
