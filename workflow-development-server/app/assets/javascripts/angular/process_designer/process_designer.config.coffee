angular.module 'WFMS.ProcessDesign'
.constant 'processDesignerConfig', 
  canvas:
    raster: 10
    panZoom:
      maxZoom: 10
      fit: false 
      minZoom: 0.5
      viewportSelector: 'g.activities'
      preventMouseEventsDefault: false

  activities:
    StartActivity:
      templateName: 'start_activity'
    EndActivity:
      templateName: 'end_activity'
    ManualActivity:
      templateName: 'manual_activity'
    OrSplitActivity:
      templateName: 'or_split_activity'
    OrJoinActivity:
      templateName: 'or_join_activity'
    AndSplitActivity:
      templateName: 'and_split_activity'
    AndJoinActivity:
      templateName: 'and_join_activity'
    AutomaticActivity:
      templateName: 'automatic_activity'
    ContainerizedActivity:
      templateName: 'containerized_activity'
