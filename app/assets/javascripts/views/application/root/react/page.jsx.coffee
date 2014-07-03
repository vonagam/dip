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
        `<div id='application_root' className='page'>
          <div className='background layer'>
            <div className='grey layer' />
          </div>
          <div className='col left'>
            <Games games={this.props.games} />
          </div>
          <div className='col right'>
            <SignIn page={this} />
            <SignUp page={this} />
            <SignOut page={this} />
            <NewGame page={this} />
            <Rules page={this} />
          </div>
        </div>`
