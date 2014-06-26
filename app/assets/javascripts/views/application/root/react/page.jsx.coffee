###* @jsx React.DOM ###

modulejs.define 'r.v.Page',
  [
  #  'r.v.SignIn'
  #  'r.v.SignUp'
    'r.v.Games'
  #  'r.v.NewGame'
  #  'r.v.Rules'
  ]
  #( SignIn, SignUp, Games, NewGame, Rules )->
  ( Games )->
    React.createClass
      getInitialState: ->
        opened_component: null
      updateCRSF: ( crsf )->
        @crsf_meta.attr content: crsf
        return
      componentDidMount: ->
        @crsf_meta = $ 'meta[name="csrf-token"]'
        return
      setOpenedComponent: ( name )->
        @setState opened_component: name
        return
      render: ->
        `<div id='application_root' className='page'>
          <div className='col left'>
            <Games games={this.props.games} />
          </div>
          <div className='col right'>
          </div>
        </div>`


###
#background.layer
  .grey.layer

        `<div id='application_root' className='page'>
          <div className='col left'>
            <Games />
          </div>
          <div className='col right'>
            <SignIn />
            <SignUp />
            <NewGame />
            <Rules />
          </div>
        </div>`
###
