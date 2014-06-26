###* @jsx React.DOM ###

modulejs.define 'r.v.Page',
  [
    'r.v.RootComponent'
    'vr.Form'
  ]
  ( RootComponent, Form )->
    React.createClass
      render: ->
        button = 

        

        `<RootComponent className='sign_in' active={}>
          <Form >
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
