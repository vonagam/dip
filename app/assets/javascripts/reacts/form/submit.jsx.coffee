###* @jsx React.DOM ###

modulejs.define 'vr.form.Submit', ->

  React.createClass
    render: ->
      @transferPropsTo(
        `<button
          type='submit'
          className='button'
        >
          {this.props.text}
          {this.props.children}
        </button>`
      )
