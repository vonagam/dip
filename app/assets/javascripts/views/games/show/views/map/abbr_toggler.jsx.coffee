###* @jsx React.DOM ###

g.view.AbbrToggler = React.createClass
  onMouseDown: (e)->
    @props.callback()
    vr.stop_event e
    return
  render: ->
    className = vr.classes 'abbrs container', hidden: @props.hide_abbrs
    `<div className={className} onMouseDown={this.onMouseDown}> 
      abbs
    </div>`
