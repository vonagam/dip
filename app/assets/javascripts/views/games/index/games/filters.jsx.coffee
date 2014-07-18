###* @jsx React.DOM ###

modulejs.define 'r.v.Filters',
  ['vr.input.Field']
  ( Field )->
    schema =
      status: collection: I18n.t 'const.game.statuses'
      sides: sub_type: 'number'
      creator: {}
      created_at: {}
      chat_mode: collection: I18n.t 'const.game.chat_modes'
      time_mode: collection: I18n.t 'const.game.time_modes'

    methods =
      sides: 'with_size'

    React.createClass
      getInitialState: -> {}
      onChange: ( field, e )->
        state = @state
        value = e.target.value
        if value
          state[field] = [ methods[field] || 'to_sym', value ]
        else
          delete state[field]
        @setState state
        return
      componentDidUpdate: ( prev_props, prev_state )->
        @props.fetch() if @state != prev_state
        return
      render: ->
        filters = {}
        for name, field_props of schema
          callback = this.onChange.bind null, name
          field = Field $.extend { label: name, onChange: callback }, field_props
          filters[name] = `<div className='td'>{field}</div>`

        `<div className='filters'>{filters}</div>`
