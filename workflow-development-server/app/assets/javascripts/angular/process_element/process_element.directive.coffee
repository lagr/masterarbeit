angular.module 'WFMS.ProcessDesign'
.directive 'processElement', ($compile, $templateCache, $templateRequest, processDesignerConfig) ->

  elementTemplate = (element) ->
    url = "/templates/process_designer/process_elements/#{processDesignerConfig.processElements[element.element_type].templateName}"
    $templateRequest(url).then -> $templateCache.get(url)

  restrict: 'A'
  templateNamespace: 'svg'
  scope:
    element: '=processElement'
  link: (scope, domElement, attrs) ->
    scope.$watch 'element', ->
      return unless scope.element?.element_type?
      templatePromise = elementTemplate(scope.element)
      templatePromise.then (template) ->
        domElement.html(template).show()
        $compile(domElement.contents())(scope)
