###* @jsx React.DOM ###

modulejs.define 'g.v.menu.Participation',
  [ 
    'vr.Component'
    'vr.Button'
    'vr.Form'
    'vr.form.fieldsFor'
    'vr.form.Submit'
    'icons'
  ]
  ( Component, Button, Form, fieldsFor, Submit, icons )->

    TEXT = I18n.t 'games.show.participation'

    React.createClass
      getInitialState: ->
        popup: false
      setPopup: (bool)->
        @setState popup: bool
      render: ->
        game = @props.game

        active = game.data.status == 'waiting'

        if active

          openCallback = @setPopup.bind null, true

          button = 
            if game.user_side == null
              Button
                className: 'yellow'
                text: icons.get 'flag', 'participation'
                onMouseDown: openCallback
            else
              {
                change: Button
                  className: 'green'
                  text: icons.get 'flag', 'change power'
                  onMouseDown: openCallback
                cancel: Button
                  href: Routes.game_side_path game.data.id, format: 'json'
                  className: 'red'
                  method: 'delete'
                  remote: true
                  text: icons.get 'flag', 'cancel participation'
              }

          if @state.popup
            fields =
              if game.data.powers_is_random
                `<div className='field powers_is_random'>
                  {TEXT.powers_is_random}
                  <input type='hidden' name='side[power]' value='' />
                </div>`
              else
                fieldsFor 'side',
                  'power':
                    label: I18n.t 'mongoid.attributes.side.power'
                    allow_blank: false
                    collection: [['','Random']].concat game.data.available_powers

            closeCallback = @setPopup.bind null, false

            popup =
              `<div id='participation_new_side' className='new_side layer'>
                <div className='content container'>
                  <div className='closer' onMouseDown={closeCallback} />
                  <Form
                    action={Routes.game_side_path(game.data.id, {format: 'json'})}
                    method='post'
                    remote='true'
                    no_redirect='true'
                  >
                    {fields}
                    <Submit className='green' text={TEXT.participate} />
                  </Form>
                </div>
              </div>`

        `<Component className='participation' active={active}>
          {button}
          {popup}
        </Component>`
