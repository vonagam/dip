###* @jsx React.DOM ###

modulejs.define 'g.v.chat.Form',
  [
    'vr.Component'
    'vr.Form'
    'vr.form.Field'
    'vr.Button'
  ]
  ( Component, Form, Field, Button )->

    React.createClass
      componentDidMount: ()->
        node = $ @getDOMNode()
        node.on 'ajax:success', ->
          node.find('textarea').val ''
          return
        return
      private_is_available: ( game )->
        game.data.status == 'going' && !game.data.chat_is_public
      form_is_available: ( game )->
        switch game.data.status
          when 'waiting' then true
          when 'going' then game.user_side && game.user_side.status != 'lost'
          when 'ended' then game.user_side
      onKeyDown: (e)->
        if e.which == 13 && !e.shiftKey
          $(@refs.form.getDOMNode()).submit()
        return
      render: ->
        game = this.props.game

        active = @form_is_available game

        if active && @private_is_available game
          options = []
          options.push if game.data.chat_mode == 'both' then 'Public' else ''
          
          for side in game.data.sides
            if ( side.status == 'fighting' || side.status == 'draw' ) && side != game.user_side
              options.push side.name

          to_select = `<Field 
            for='message' attr='to'
            type='select' label='hello'
            collection={options} 
          />`

        `<Component active={active}>
          <Form
            ref='form'
            id='new_message'
            action={Routes.game_messages_path( game.data.id, { format: 'json' } )}
            method='post'
            className='new_message'
            no_redirect='true'
            remote='true'
            onKeyDown={this.onKeyDown}
          >
            {to_select}
            <Field for='message' attr='text' type='Text' placeholder='message' />
            <Button className='yellow' text='send' />
          </Form>
        </Component>`
