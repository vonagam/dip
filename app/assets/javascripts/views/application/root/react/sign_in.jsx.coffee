###* @jsx React.DOM ###

modulejs.define 'r.v.Page',
  [
    'r.v.RootComponent'
    'vr.Form'
    'vr.form.input.Hidden'
  ]
  ( RootComponent, Form, HiddenInput )->
    React.createClass
      render: ->
        button = 

        

        `<RootComponent className='sign_in' active={}>
          <Form
            action={Routes.session_path('user', {format: 'json'})}
            method='post'
            remote='true'
            no_redirect='true'
          >
            <HiddenInput for='user' attr='remember_me' value='1' />
            <Field for='user' attr='login' type='String' />
            <Field for='user' attr='password' type='Password' />

          </Form>
        </RootComponent>`



.sign_in.container
  .closer
  = simple_form_for User.new, data: { no_redirect: true },
    url: session_path('user', format: :json), remote: true do |f|

    = f.hidden_field :remember_me, value: 1

    .fields
      = f.input :login, hint: false
      = f.input :password

    = f.button :button, t('.in'), class: 'green'
