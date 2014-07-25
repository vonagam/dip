###* @jsx React.DOM ###

modulejs.define 'v.g.s.chat.Form',
  [
    'cancan'
    'vr.Component'
    'vr.Form'
    'vr.form.Field'
    'vr.form.Submit'
  ]
  ( can, Component, Form, Field, Submit )->

    React.createClass
      componentDidMount: ()->
        node = $ @getDOMNode()
        node.on 'ajax:success', ->
          node.find('textarea').val ''
          return
        return
      onKeyDown: (e)->
        if e.which == 13 && !e.shiftKey
          $(@refs.form.getDOMNode()).submit()
        return
      render: ->
        game = @props.game
        user = @props.user

        active = can user, 'create message', game

        if active && game.private_chat_is_available
          options = []
          options.push if game.chat_mode == 'both' then 'Public' else ''
          
          for side in game.sides
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
            action={Routes.game_messages_path( game.id, { format: 'json' } )}
            method='post'
            className='new_message'
            no_redirect='true'
            remote='true'
            onKeyDown={this.onKeyDown}
          >
            {to_select}
            <Field for='message' attr='text' placeholder='message' />
            <Submit className='green' text='send' />
          </Form>
        </Component>`
