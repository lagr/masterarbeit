angular.module 'WFMS.ProcessDesign'
.directive 'activity', ($compile, $templateCache, $templateRequest, processDesignerConfig) ->

  activityTemplate = (activity) ->
    url = "/templates/process_designer/activities/#{processDesignerConfig.activities[activity.activity_type].templateName}"
    $templateRequest(url).then -> $templateCache.get(url)

  restrict: 'A'
  templateNamespace: 'svg'
  scope:
    activity: '=activity'
  link: (scope, domElement, attrs) ->
    scope.activity.domElement = domElement

    scope.$watch 'activity', ->
      return unless scope.activity?.activity_type?
      templatePromise = activityTemplate(scope.activity)
      templatePromise.then (template) ->
        domElement.html(template).show()
        $compile(domElement.contents())(scope)
