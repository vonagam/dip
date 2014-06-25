###* @jsx React.DOM ###

modulejs.define 'g.v.map.svg.Polygon', 
  [ 'g.v.map.order.isSelectable' ]
  ( isSelectable )->

    React.createClass
      render: ->
        polygon = @props.polygon

        options = className: polygon.type
        
        if polygon.part
          options.id = "#{@props.region}_#{polygon.part}"
          $.merge options, isSelectable options.id, @props.control

        if polygon.d
          options.d = polygon.d
          type = 'path'
        else
          options.points = polygon.points
          type = if polygon.part then 'polyline' else 'polygon'

        React.DOM[type]( options )
