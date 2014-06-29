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
        button = className: 'green', text: 'new_game'

        fields = fieldsFor { for: 'game' },
          name: label: 'name', hint: 'hint'
          map: label: 'map', collection: [1,2,3]
          time_mode: label: 'time_mode', type: 'radigos', collection: [[1,1],[2,2],[3,3]]
          chat_mode: label: 'chat_mode', collection: [[1,1],[2,2],[3,3]]
          #is_public: label: 'is_public'
          #powers_is_random: label: 'powers_is_random'


        `<RootComponent
          className='container'
          name='new_game'
          enabled={true}
          page={this.props.page}
          button={button}
        >
          <Form
            action={Routes.games_path({format: 'json'})}
            method='post'
            remote='true'
          >
            {fields}
            <Submit className='green' text='new_game' />
          </Form>
        </RootComponent>`
