svg_helpers =
  to_relative_coordinates: (activity, clientX, clientY) ->
    bbRect = activity.getBoundingClientRect()
    [x, y] = [clientX - bbRect.left, clientY - bbRect.top]

_.mixin svg_helpers: _.constant(svg_helpers)
