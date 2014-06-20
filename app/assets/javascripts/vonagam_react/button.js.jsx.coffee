###* @jsx React.DOM ###

vr.Button = React.createClass
  render: ->
    @transferPropsTo(
      `<a 
        className={vr.classes( 'button', this.props.color, this.props.className )}
        data-remote={this.props.remote}
        data-method={this.props.method}
        data-confirm={this.props.confirm}
        remote={null} 
        method={null} 
        confirm={null}
      >
        {this.props.children}
      </a>`
    )
