angular.module 'WFMS.Infrastructure'
.controller 'ServerPageController', (tab, pageData, PageController) ->
  class DockerImage
    constructor: (@id, @name, @required, @installed) ->

  vm = new PageController(tab, pageData)
  vm.setPageTitle 'Server'

  pageData.server.then (server) ->
    vm.server = server
    vm.setPageTitle vm.server.name

  pageData.images.then (images) ->
    vm.images = (new DockerImage(image.id, image.name, true) for image in images.required)
    for image in images.installed
      requiredImage = _.find(vm.images, name: image.name)
      if requiredImage
        requiredImage.installed = true
      else    
        vm.images.push new DockerImage(image.id, image.name, false, true)

    vm.images = _.sortBy(vm.images, 'name')

  vm.imageStatusClass = (image) ->
    return 'icon-circleselection' unless image.required
    
    if image.installed
      'icon-circleselect'
    else
      'icon-erroralt'
    
  vm
