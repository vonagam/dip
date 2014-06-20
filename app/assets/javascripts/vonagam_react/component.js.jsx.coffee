###* @jsx React.DOM ###

vr.Component = React.createClass
  render: ->
    @transferPropsTo(
      `<div 
        className={vr.classes( 'component', this.props.name, this.props.className )}
        name={null}
      >
        {this.props.children}
      </div>`
    )
