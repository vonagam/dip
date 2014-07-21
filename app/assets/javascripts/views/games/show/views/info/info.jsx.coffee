###* @jsx React.DOM ###

modulejs.define 'g.v.Info',
  [],
  ->
    React.createClass
      render: ->
        info = @props.game.data
        log info

        `<div className='container'>
          <div className='name'>{info.name}</div>
        </div>`
