###* @jsx React.DOM ###

modulejs.define 'r.v.Page',
  [
    'r.v.SignIn'
    'r.v.SignUp'
    'r.v.SignOut'
    'r.v.Games'
    'r.v.NewGame'
    'r.v.Rules'
  ]
  ( SignIn, SignUp, SignOut, Games, NewGame, Rules )->
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
        is_signed_in = @props.access.user != undefined

        `<div id='application_root' className='page'>
          <div className='background layer'>
            <div className='grey layer' />
          </div>
          <div className='col left'>
            <Games data={this.props.games_index} />
          </div>
          <div className='col right'>
            <SignIn page={this} is_signed_in={is_signed_in} />
            <SignUp page={this} is_signed_in={is_signed_in} />
            <SignOut page={this} is_signed_in={is_signed_in} />
            <NewGame page={this} is_signed_in={is_signed_in} />
            <Rules page={this} />
          </div>
        </div>`
