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
        button = className: 'green in_form'

        fields = fieldsFor 'user',
          login: label: I18n.t('attributes.login'), hint: I18n.t('simple_form.hints.user.login')
          password: label: I18n.t('attributes.password')

        `<RootComponent
          className='container'
          name='sign_up'
          enabled={!this.props.is_signed_in}
          page={this.props.page}
          button={button}
          form_access={true}
        >
          <Form
            action={Routes.user_registration_path({format: 'json'})}
            method='post'
            remote='true'
            no_redirect='true'
          >
            {fields}
            <Submit className='yellow' text={I18n.t('application.root.sign_up.button')} />
          </Form>
        </RootComponent>`
