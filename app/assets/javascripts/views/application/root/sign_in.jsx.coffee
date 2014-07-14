###* @jsx React.DOM ###

modulejs.define 'r.v.SignIn',
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

        fields = fieldsFor 'user',
          login: label: 'login'
          password: label: 'password'
          remember_me: sub_type: 'hidden', value: 1

        `<RootComponent
          className='container'
          name='sign_in'
          enabled={true}
          page={this.props.page}
          button={button}
        >
          <Form
            action={Routes.user_session_path({format: 'json'})}
            method='post'
            remote='true'
            no_redirect='true'
          >
            {fields}
            <Submit className='green' text='sign_in' />
          </Form>
        </RootComponent>`
