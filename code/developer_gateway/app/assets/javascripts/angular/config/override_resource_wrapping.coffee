angular.module('rails')
.factory 'railsRootWrapper', ->
  wrap: (data, resource) ->
    result = {}
    key = if angular.isArray(data) then resource.config.pluralName else resource.config.name
    result[key] = data
    result

  unwrap:  (response, resource) ->
    response.data = response.data[resource.config.name]       if response.data.hasOwnProperty(resource.config.name)
    response.data = response.data[resource.config.pluralName] if response.data.hasOwnProperty(resource.config.pluralName)

    if angular.isArray(response.data)
      for elem, i in response.data
        response.data[i] = elem[resource.config.name] if elem[resource.config.name]

    response
