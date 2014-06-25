###* @jsx React.DOM ###

modulejs.define 'g.v.map.AbbrToggler',
  [ 'vr.classes', 'vr.stopEvent' ]
  ( classes, stopEvent )->

    React.createClass
      onMouseDown: (e)->
        @props.callback()
        stopEvent e
        return
      render: ->
        className = classes 'abbrs container', hidden: @props.hide_abbrs
        `<div className={className} onMouseDown={this.onMouseDown}> 
          abbs
        </div>`
