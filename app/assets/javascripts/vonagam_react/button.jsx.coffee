###* @jsx React.DOM ###

modulejs.define 'vr.Button', ->

  React.createClass
    render: ->
      @transferPropsTo(
        `<a
          className='button'
          data-remote={this.props.remote}
          data-method={this.props.method}
          data-confirm={this.props.confirm}
        >
          {this.props.text}
          {this.props.children}
        </a>`
      )
