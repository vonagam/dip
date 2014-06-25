###* @jsx React.DOM ###

modulejs.define 'vr.Form', ->

  React.createClass
    render: ->
      @transferPropsTo(
        `<form 
          accept-charset='UTF-8'
          className='form'
          data-remote={this.props.remote} remote={null}
          data-no-redirect={this.props.no_redirect} no_redirect={null}
        >
          <div style={{display:'inline'}}><input name='utf8' type='hidden' value='✓' /></div>
          {this.props.children}
        </form>`
      )
