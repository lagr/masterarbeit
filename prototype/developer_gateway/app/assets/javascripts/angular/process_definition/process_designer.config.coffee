angular.module 'WFMS.ProcessDefinition'
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
      templateName: 'start'
    EndActivity:
      templateName: 'end'
    ManualActivity:
      templateName: 'manual'
    OrSplitActivity:
      templateName: 'or_split'
    OrJoinActivity:
      templateName: 'or_join'
    AndSplitActivity:
      templateName: 'and_split'
    AndJoinActivity:
      templateName: 'and_join'
    ContainerizedActivity:
      templateName: 'containerized'
