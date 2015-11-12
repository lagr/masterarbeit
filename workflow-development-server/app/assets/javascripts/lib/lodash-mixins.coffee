svg_helpers =
  to_relative_coordinates: (element, clientX, clientY) ->
    bbRect = element.getBoundingClientRect()
    [x, y] = [clientX - bbRect.left, clientY - bbRect.top]

_.mixin svg_helpers: _.constant(svg_helpers)
