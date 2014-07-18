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
          login: label: I18n.t 'attributes.login'
          password: label: I18n.t 'attributes.password'
          remember_me: sub_type: 'hidden', value: 1

        `<RootComponent
          className='container'
          name='sign_in'
          enabled={!this.props.is_signed_in}
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
            <Submit className='green' text={I18n.t('application.root.sign_in.button')} />
          </Form>
        </RootComponent>`
