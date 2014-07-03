###* @jsx React.DOM ###

modulejs.define 'r.v.SignUp',
  [
    'r.v.RootComponent'
    'vr.Form'
    'vr.form.fieldsFor'
    'vr.form.Submit'
  ]
  ( RootComponent, Form, fieldsFor, Submit )->
    React.createClass
      render: ->
        button = className: 'yellow in_form'

        fields = fieldsFor 'user',
          login: label: 'login', hint: 'hint'
          password: label: 'password', hint: 'hint'

        `<RootComponent
          className='container'
          name='sign_up'
          enabled={true}
          page={this.props.page}
          button={button}
        >
          <Form
            action={Routes.user_registration_path({format: 'json'})}
            method='post'
            remote='true'
            no_redirect='true'
          >
            {fields}
            <Submit className='yellow' text='sign_up' />
          </Form>
        </RootComponent>`
