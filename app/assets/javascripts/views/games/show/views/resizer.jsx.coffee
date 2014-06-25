###* @jsx React.DOM ###

modulejs.define 'g.v.Resizer', ['vr.stopEvent'], ( stopEvent )->

  React.createClass
    getInitialState: ->
      dragging: false
      offset: 0
      percent: parseFloat( $.cookie 'percent' ) || 50
    onMouseDown: (e)->
      @setState dragging: true, offset: e.pageX - e.target.offsetLeft
      stopEvent e
      return
    onMouseUp: (e)->
      $.cookie 'percent', @state.percent
      @setState dragging: false, offset: 0
      stopEvent e
      return
    onMouseMove: (e)->
      first_left = @refs.leftPart.getDOMNode().offsetLeft

      mouse_left = e.pageX - @state.offset
      
      percent = ( mouse_left - first_left ) / $(@getDOMNode()).width() * 100

      percent = Math.min 70, Math.max 30, percent

      @setState percent: percent

      stopEvent e
      return
    componentDidUpdate: ( props, prev_state )->
      if @state.dragging != prev_state.dragging
        @toggle_listeners @state.dragging
      return
    componentWillUnmount: ->
      @toggle_listeners false
      return
    toggle_listeners: ( bool )->
      toggle = if bool then 'addEventListener' else 'removeEventListener'
      document[toggle] 'mousemove', @onMouseMove
      document[toggle] 'mouseup', @onMouseUp
    render: ->
      `<div className='pils2'>
        <div ref='leftPart' className='pil left' style={ { 'width': this.state.percent + '%' } }>
          { this.props.children[0] }
        </div>
        <div className='resizer' onMouseDown={ this.onMouseDown } />
        <div className='pil right' style={ { 'width': (100 - this.state.percent) + '%' } }>
          { this.props.children[1] }
        </div>
      </div>`
