###* @jsx React.DOM ###

modulejs.define 'r.v.NewGame',
  [
    'r.v.RootComponent'
    'vr.Form'
    'vr.form.fieldsFor'
    'vr.form.Submit'
  ]
  ( RootComponent, Form, fieldsFor, Submit )->
    React.createClass
      render: ->
        button = className: 'green in_form'

        maps = @props.page.props.maps.map (map)-> [ map.id, map.name ]

        fields = fieldsFor 'game',
          _labels: I18n.t 'mongoid.attributes.game'
          name: hint: I18n.t 'simple_form.hints.game.name'
          map: collection: maps, allow_blank: false
          time_mode: type: 'radigos', collection: I18n.t 'const.game.time_modes'
          chat_mode: type: 'radigos', collection: I18n.t 'const.game.chat_modes'
          is_public: {}
          powers_is_random: {}

        `<RootComponent
          className='container'
          name='new_game'
          enabled={this.props.is_signed_in}
          page={this.props.page}
          button={button}
        >
          <Form
            className='new_game'
            action={Routes.games_path({format: 'json'})}
            method='post'
            remote='true'
          >
            {fields}
            <Submit className='green' text={I18n.t('application.root.new_game.button')} />
          </Form>
        </RootComponent>`
