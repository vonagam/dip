###* @jsx React.DOM ###

vr.Button = React.createClass
  render: ->
    `<a 
      className={vr.classes( 'button', this.props.color, this.props.className )} 
      href={this.props.href}
      data-remote={this.props.remote}
      data-method={this.props.method}
      data-confirm={this.props.confirm}
    >
      {this.props.children}
    </a>`
