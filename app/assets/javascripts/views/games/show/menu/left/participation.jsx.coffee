###* @jsx React.DOM ###

modulejs.define 'v.g.s.menu.Participation',
  [ 
    'cancan'
    'vr.Component'
    'vr.Button'
    'vr.Form'
    'vr.form.fieldsFor'
    'vr.form.Submit'
    'icons'
  ]
  ( can, Component, Button, Form, fieldsFor, Submit, icons )->

    TEXT = I18n.t 'games.show.participation'

    React.createClass
      getInitialState: ->
        popup: false
      setPopup: (bool)->
        @setState popup: bool
      getAvailabePowers: (game)->
        powers = [['','Random']].concat game.available_powers()
        if game.user_side && game.user_side.power?[0]
          powers.push game.user_side.power[0]
        powers
      componentDidMount: ->
        $(@getDOMNode()).on 'ajax:success', =>
          @setPopup false if @state.popup
        return
      render: ->
        game = @props.game

        active = game.status == 'waiting'

        if active

          openCallback = @setPopup.bind null, true

          if can 'create side', game
            create = Button
              className: 'green'
              text: icons.get 'flag', TEXT.create
              onMouseDown: openCallback

          if can 'update side', game
            update = Button
              className: 'yellow'
              text: icons.get 'flag', TEXT.update
              onMouseDown: openCallback

          if can 'destroy side', game
            destroy = Button
              href: Routes.game_side_path game.id, format: 'json'
              className: 'red'
              method: 'delete'
              remote: true
              text: icons.get 'flag', TEXT.destroy

          if @state.popup

            closeCallback = @setPopup.bind null, false

            submit =
              if game.user_side
                [ 'yellow', TEXT.update ]
              else
                [ 'green', TEXT.create ]

            fields =
              if game.powers_is_random
                `<div className='field powers_is_random'>
                  {TEXT.powers_is_random}
                  <input type='hidden' name='side[power]' value='' />
                </div>`
              else
                fieldsFor 'side',
                  'power':
                    label: I18n.t 'mongoid.attributes.side.power'
                    allow_blank: false
                    collection: @getAvailabePowers game
                    value: game.user_side?.power?[0]

            popup =
              `<div id='participation_new_side' className='new_side layer'>
                <div className='content container'>
                  <div className='closer' onMouseDown={closeCallback} />
                  <Form
                    className='new_side'
                    action={Routes.game_side_path(game.id, {format: 'json'})}
                    method='post'
                    remote='true'
                    no_redirect='true'
                  >
                    {fields}
                    <Submit className={submit[0]} text={submit[1]} />
                  </Form>
                </div>
              </div>`

        `<Component className='participation' active={active}>
          {create}
          {update}
          {destroy}
          {popup}
        </Component>`
