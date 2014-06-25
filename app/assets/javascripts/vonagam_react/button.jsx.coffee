###* @jsx React.DOM ###

modulejs.define 'vr.Button', ->

  React.createClass
    render: ->
      @transferPropsTo(
        `<a
          className='button'
          data-remote={this.props.remote} remote={null}
          data-method={this.props.method} method={null}
          data-confirm={this.props.confirm} confirm={null}
        >
          {this.props.text}
          {this.props.children}
        </a>`
      )
