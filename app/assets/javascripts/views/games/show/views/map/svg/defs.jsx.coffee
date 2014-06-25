###* @jsx React.DOM ###

modulejs.define 'g.v.map.svg.Defs', ->

  React.createClass
    addMarkers: ->
      defs = d3.select @getDOMNode()

      defs
      .append 'marker'
      .attr id: 'move_marker', markerWidth: 8, markerHeight: 10, refX: 3, refY: 5, orient: 'auto'
      .append 'polygon'
      .attr points: '2,2 6,5 2,8'

      defs
      .append 'marker'
      .attr id: 'support_marker', markerWidth: 3, markerHeight: 3, refX: 1.5, refY: 1.5
      .append 'circle'
      .attr cx: 1.5, cy: 1.5, r: 1.5

      return
    componentDidMount: -> @addMarkers()
    componentDidUpdate: -> @addMarkers()
    shouldComponentUpdate: -> false
    render: -> `<defs />`
