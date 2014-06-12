class g.model.Order.Disband extends g.model.Order.Base
  constructor: ->
    super
    @type = 'Disband'

  create_visualization: ->
    g.svgs.get 'disband', @view_class_name(), @unit.coords

  to_string: -> 'D'
