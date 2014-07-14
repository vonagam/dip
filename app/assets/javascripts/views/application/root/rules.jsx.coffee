###* @jsx React.DOM ###

modulejs.define 'r.v.Rules',
  [
    'r.v.RootComponent'
  ]
  ( RootComponent )->
    React.createClass
      render: ->
        button = className: 'blue'

        `<RootComponent
          className='container'
          name='rules'
          enabled={true}
          page={this.props.page}
          button={button}
        >
        </RootComponent>`
