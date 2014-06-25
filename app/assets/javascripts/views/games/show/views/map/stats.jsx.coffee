###* @jsx React.DOM ###

modulejs.define 'g.v.map.Stats', ->

  React.createClass
    render: ->
      powers = []

      for name, power of @props.state.powers
        powers.push `<tr key={name} className={name}>
          <td className='power'>{name}</td>
          <td className='supplies'>{power.units.length}</td>
          <td className='units'>{power.supplies().length}</td>
        </tr>`

      `<div className='stats container'>
        <div className='word'>statistic</div>
        <div className='container'>
          <table>
            <thead>
              <tr><th>power</th><th>supplies</th><th>units</th></tr>
            </thead>
            <tbody>
              {powers}
            </tbody>
          </table>
        </div>
      </div>`
