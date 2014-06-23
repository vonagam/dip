###* @jsx React.DOM ###



ChekOrderControl = ( name, order_control )->
  if order_control && order_control[0].indexOf(name) != -1
    'data-selectable': true, 'onMouseDown': order_control[1].bind this, name
  else
    'data-selectable': null, 'onMouseDown': null



vr.Orders = React.createClass
  getInitialState: ->
    selecting: false
    selectable: []
    selected: null
    callback: null

  changeSelecting: ( callback, args... )->
    @setState callback.apply this, args

