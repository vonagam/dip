###* @jsx React.DOM ###

modulejs.define 'r.v.SignOut',
  [
    'r.v.RootComponent'
    'vr.Form'
    'vr.form.fieldsFor'
    'vr.form.Submit'
  ]
  ( RootComponent, Form, fieldsFor, Submit )->
    React.createClass
      render: ->
        button = 
          className: 'red'
          remote: true
          href: Routes.destroy_user_session_path format: 'json'

        `<RootComponent
          className='container'
          name='sign_out'
          enabled={this.props.page.props.user != undefined}
          page={this.props.page}
          button={button}
        />`
