angular.module 'WFMS.ProcessDefinition'
.directive 'activity', ($compile, $templateCache, $templateRequest) ->

  activityTemplate = (activity) ->
    url = "/templates/process_designer/elements/#{activity.activityType}"
    $templateRequest(url).then -> $templateCache.get(url)

  restrict: 'A'
  templateNamespace: 'svg'
  scope:
    activity: '=activity'
  link: (scope, domElement, attrs) ->
    scope.domElement = domElement

    scope.$watch 'activity', ->
      return unless scope.activity?.activityType?
      templatePromise = activityTemplate(scope.activity)
      templatePromise.then (template) ->
        domElement.html(template).show()
        $compile(domElement.contents())(scope)
