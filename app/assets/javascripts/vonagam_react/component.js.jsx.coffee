###* @jsx React.DOM ###

vr.Component = React.createClass
  render: ->
    `<div 
      className={vr.classes( 'component', this.props.name, this.props.className )} 
    >
      {this.props.children}
    </div>`
