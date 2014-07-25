###* @jsx React.DOM ###

modulejs.define 'v.g.s.Info', ->
  React.createClass
    render: ->
      game = @props.game

      `<div className='container'>
        <div className='name'>{game.name}</div>
      </div>`
