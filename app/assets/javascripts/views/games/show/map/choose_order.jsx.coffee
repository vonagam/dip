###* @jsx React.DOM ###

modulejs.define 'v.g.s.map.ChooseOrder', 
  [ 'vr.Component', 'vr.Button' ]
  ( Component, Button )->

    React.createClass
      maneuvers: ['move', 'hold', 'support']
      keys: { 77: 'move', 72: 'hold', 83: 'support' }
      onKeyDown: (e)->
        if @active
          if maneuver = @keys[e.which]
            if ref = @refs[maneuver]
              ref.onMouseDown()
        return
      componentDidMount: ->
        doc.on 'keydown', @onKeyDown
        return
      componentWillUnmount: ->
        doc.off 'keydown', @onKeyDown
        return
      render: ->
        control = @props.control
        changeOrder = @props.changeOrder

        @active = control.selected && @props.state.type == 'Move'

        if @active
          buttons = {}
          for maneuver in @maneuvers
            continue if control.step.indexOf(maneuver) != -1
            callback = changeOrder.bind null, modulejs.require('v.g.s.map.order.move.'+maneuver)
            buttons[maneuver] = 
            `<Button
              ref={maneuver}
              className='grey' 
              onMouseDown={callback} 
              text={maneuver} 
            />`

        `<Component className='choose_order container' active={this.active}>
          {buttons}
        </Component>`
