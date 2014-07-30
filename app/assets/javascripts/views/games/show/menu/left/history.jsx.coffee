###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.History',
  [ 'vr.Component', 'vr.classes', 'vr.input.Select' ]
  ( Component, classes, Select )->

    React.createClass
      controls: ->
        'back all': (x,max)-> 0
        'back one': (x,max)-> x-1
        'forward one': (x,max)-> x+1
        'forward all': (x,max)-> max
      state_label: ( state )->
        year = parseInt state.date / 2
        season = state.date % 2
        "#{year}.#{season}:#{state.type}"
      set_state_by_index: ( index )->
        @props.page.setGameState @props.game.states[index]
        return
      onChange: (e)->
        @set_state_by_index e.target.value
        return
      onKeyDown: (e)->
        if e.shiftKey && @active
          @refs['back one'].props.onMouseDown() if e.which == 37
          @refs['forward one'].props.onMouseDown() if e.which == 39
        return
      componentDidMount: ->
        document.addEventListener 'keydown', @onKeyDown
        return
      componentWillUnmount: ->
        document.removeEventListener 'keydown', @onKeyDown
        return
      render: ->
        game = @props.game

        @active = game.status != 'waiting'

        if @active
          states = game.states

          controls = {}
          current = states.indexOf game.state
          max = states.length - 1
          for name, fun of @controls()
            move_to = Math.max 0, Math.min max, fun current, max
            control_classes = classes 'control', name, hidden: move_to == current

            controls[name] = 
              `<div 
                ref={name}
                className={control_classes}
                onMouseDown={this.set_state_by_index.bind(this,move_to)}
              >
                <div className='press' />
              </div>`

          select = Select 
            className: 'input'
            value: current
            onChange: @onChange
            collection: states.map (state, index)=> [ index, @state_label(state) ]

        `<Component className='history' active={this.active}>
          {select}
          <div className='controls row'>
            {controls}
          </div>
        </Component>`
